//
//  SharedInfoViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 6. 17..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class SharedInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var fetchedArray: [DetailDayInfoData] = Array()

    @IBOutlet var tableView: UITableView!
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

        labelTitle.text = sharedData.title
        labelArea.text = sharedData.area
        labelUserid.text = sharedData.user_id
        labelStartDate.text = sharedData.start_date
        labelRecommend.text = sharedData.recommend_reason
        labelEndDate.text = sharedData.end_date
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchedArray = []
        self.downloadDataFromServer()
        
    }
    
    // Table view 관련
    func numberOfSections (in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mypage Detail Info Cell", for: indexPath) as! DetailInfoTableCell
        
        let item = fetchedArray[indexPath.row]
        
        cell.labelDayCount.text = "\(item.day_count)"
        cell.labelCost.text = "\(item.cost)"
        cell.labelDay.text = item.place
        
        return cell
    }
    
    // 서버에서 데이터 로드
    // detail만 하면 될듯
    func downloadDataFromServer() -> Void {
        //        let urlString: String = "http://localhost:8888/favorite/favoriteTable.php"
        let urlString: String = "http://condi.swu.ac.kr/student/T03nolleo/selectDetailInfo.php"
        
        guard let requestURL = URL(string: urlString) else { return }
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "POST"
        
        // 변수 전달
        // 안되면 지우기
        let restString: String = "&title=" + labelTitle.text! + "&user_id=" + labelUserid.text!
        request.httpBody = restString.data(using: .utf8)
        
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
                        let newData: DetailDayInfoData = DetailDayInfoData()
                        var jsonElement = jsonData[i]
                        newData.day_count = jsonElement["day_count"] as! String
                        newData.place = jsonElement["place"] as! String
                        newData.cost = jsonElement["cost"] as! String
                        newData.detail_user_id = jsonElement["detail_user_id"] as! String
                        newData.detail_title = jsonElement["detail_title"] as! String
                    
                        self.fetchedArray.append(newData)
                    }
                    DispatchQueue.main.async { self.tableView.reloadData() }
//                    print("ddfsfsdf : \(fetchedArray[0].place)")
                    
                }
            } catch { print("Error shared:") } }
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
