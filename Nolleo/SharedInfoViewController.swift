//
//  SharedInfoViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 6. 17..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class SharedInfoViewController: UIViewController {
    
    var fetchedArray: [BasicInfoData] = Array()

    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelArea: UILabel!
    @IBOutlet var labelStartDate: UILabel!
    @IBOutlet var labelEndDate: UILabel!
    @IBOutlet var labelSavedDate: UILabel!
    @IBOutlet var labelUserid: UILabel!
    @IBOutlet var labelRecommend: UITextView!
    
    var selectedData: BasicInfoData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let sharedData = selectedData else { return }

        // Do any additional setup after loading the view.
        labelTitle.text = sharedData.title
        labelArea.text = sharedData.area
        labelUserid.text = sharedData.user_id
        labelStartDate.text = sharedData.start_date
        labelRecommend.text = sharedData.recommend_reason
        labelEndDate.text = sharedData.end_date
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        // 서버에서 데이터 가져옴
        self.downloadDataFromServer()
        
    }
    
    // 서버에서 데이터 로드
    func downloadDataFromServer() -> Void {
        //        let urlString: String = "http://localhost:8888/favorite/favoriteTable.php"
        let urlString: String = "http://condi.swu.ac.kr/student/T03nolleo/selectBasicInfo.php"
        
        guard let requestURL = URL(string: urlString) else { return }
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("Error: calling POST"); return; }
            guard let receivedData = responseData else {
                print("Error: not receiving Data"); return; }
            
            let response = response as! HTTPURLResponse
            if !(200...299 ~= response.statusCode) { print("HTTP response Error!"); return }
            do {
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData,options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                        let newData: BasicInfoData = BasicInfoData()
                        var jsonElement = jsonData[i]
                        newData.index = jsonElement["index"] as! String
                        newData.title = jsonElement["title"] as! String
                        newData.user_id = jsonElement["user_id"] as! String
                        newData.area = jsonElement["area"] as! String
                        newData.start_date = jsonElement["start_date"] as! String
                        newData.end_date = jsonElement["end_date"] as! String
                        newData.recommend_reason = jsonElement["recommend_reason"] as! String
                        self.fetchedArray.append(newData)
                    }
//                    DispatchQueue.main.async { self.tableView.reloadData() }
                    
                }
            } catch { print("Error:") } }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 뒤로가기 버튼 클릭
    @IBAction func backPressed() {
         self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
