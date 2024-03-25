//
//  ViewController.swift
//  post
//
//  Created by apple on 8/17/23.
//

import UIKit
struct code:Codable{
    let status: String
    let modelList: [String]
}


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsondata?.modelList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pass",for: indexPath) as! TableViewCell
        cell.lbl1.text = jsondata?.modelList[indexPath.row]
        cell.lbl2.text = jsondata?.status
        print(cell)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        response()
        
    }
    
    var jsondata: code?
    
    func  response(){
        
        let url = "https://kuwycredit.in/servlet/rest/ltv/forecast/ltvModels"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "post"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var params:[String:Any] = ["year":"2020","make":"RENAULT"]
        
        do{
            
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            let task = URLSession.shared.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
                
                
                
                //response
                if let response = response{
                    let nsHTTPResponse = response as! HTTPURLResponse
                    let statuscode = nsHTTPResponse.statusCode
                    print("status code = \(statuscode)")
                }
                //error
                if let error = error{
                    print("\(error)")
                }
                //data
                if let data = data{
                    do{
                        let content = try? JSONDecoder().decode(code.self, from: data)
                        self.jsondata = content
                        print(content)
                        DispatchQueue.main.async {
                            self.tableview.reloadData()
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            })
            task.resume()
            
        }catch{
            print("oops")
        }
    }
    
}

