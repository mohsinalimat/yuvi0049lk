//
//  ShopMenu.swift
//  Leuk_iOS
//
//  Created by yuvraj singh on 29/04/17.
//  Copyright © 2017 yuvi0049. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShopMenu: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	
	@IBOutlet weak var myTableView: UITableView!
       var indexValueShop: Int!
	//var totalValueHere: [Int]!
	var menuFoodId: String!
	var indexValueSender : Int!
	

    override func viewDidLoad() {
        super.viewDidLoad()

	
	myTableView.tableFooterView = UIView()
	
	
	
	//MARK:- todo
//	let btn1 = UIButton(type: .custom)
//	btn1.setImage(UIImage(named: "parties"), for: .normal)
//	btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//	btn1.addTarget(self, action: #selector(self.callCartScene), for: .touchUpInside)
//	let item1 = UIBarButtonItem(customView: btn1)
//	
//	self.navigationItem.setRightBarButtonItems([item1], animated: true)
	
	
    }
	
	
	func callCartScene(){
		// Method for calling cart through navbar
		
		
		
	}
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	// MARK:- tableview functionalities
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		
//		if categoryOfItem.count == 0 {
//			callTimer()
//		}
		return categoryOfItem.count
	}
	
	
	
	
	func callTimer(){
		
		if categoryOfItem.count == 0 {
			DispatchQueue.main.async {
				
				_ = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.callTimer), userInfo: nil, repeats: true);
			}
		}
		//tableView.reloadData()
		
	}
		
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ShopMenuTVCell", for: indexPath) as! ShopMenuTVCell
		
		cell.itemName.text = categoryOfItem[indexPath.row]
		
		
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		
		let categoryVal = categoryOfItem[indexPath.row]
		indexValueSender = indexPath.row
		apiCall(categoryVal)
		//addArray(categoryVal)
		
		
	}
	
	func addArray(_ category: String){
		
		for values in commonForShop {
			if values.itemCategory == category {
				commonForShopAtlast1.append(values)
				print(values.itemCategory)
			}
		}
		print("YSYSYSYSY\(commonForShopAtlast1)")
		
		DispatchQueue.main.async {
			self.performSegue(withIdentifier: "shopconnect", sender: self)

		}
		

		
		
	}
	
	
	
	func apiCall(_ value: String){
		
		
		
		// MARK:- Api call for getMenubyCategory
		
		var getMenu = URLRequest(url: URL(string: "\(LEUK_URL)\(PHP_INDEX)method=getMenubyCategory")!)
		getMenu.httpMethod = "POST"
		let postValue="key=\(UNIVERSAL_KEY)&secret=\(SECRET)&sessionid=\(SESSION_ID!)&token=\(TOKEN_ID_FROM_LEUK!)&place_id=\(menuFoodId!)&category=\(value)"
		print("YSHSHSHSHSHS \(postValue)")
		
		
		getMenu.httpBody = postValue.data(using: .utf8)
		
		let task2 = URLSession.shared.dataTask(with: getMenu) { data, response, error in
			if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
				print("statusCode should be 200, but is \(httpStatus.statusCode)")
				//print("response = \(response)")
			}
				
			else {
				
				
				var json = JSON(data: data!)
				print(json)
				let numberOfItems = json["response"]["data"].count
				print("YSYSYSYSY\(numberOfItems)")
				
//				for value in 0..<numberOfItems{
//					
////					quantity[value] = 0
//					
//				}

				
				if numberOfItems > 0
				{
					for index in 0...numberOfItems-1 {
						let menuList = shopMenuItem()
						menuList.itemId = json["response"]["data"][index]["id"].string!
						menuList.itemNonVeg = json["response"]["data"][index]["non_veg"].string!
						menuList.itemOfferCost = json["response"]["data"][index]["offer_cost"].string!
						menuList.itemCategory = json["response"]["data"][index]["category"].string!
						menuList.itemDescription = json["response"]["data"][index]["description"].string!
						menuList.itemName = json["response"]["data"][index]["item_name"].string!
						menuList.itemLimit = json["response"]["data"][index]["item_limit"].string!
						menuList.itemVeg = json["response"]["data"][index]["veg"].string!
						menuList.itemtags = json["response"]["data"][index]["tags"].string!
						menuList.itemspicy = json["response"]["data"][index]["spicy"].string!
						menuList.itemLove = json["response"]["data"][index]["love"].string!
						menuList.itemImageLink = json["response"]["data"][index]["image"].string!
						menuList.itemPlaceId = json["response"]["data"][index]["place_id"].string!
						menuList.itemRegularCost = json["response"]["data"][index]["regular_cost"].string!
						menuList.rows = 0
						menuList.minimumSpending = json["response"]["data"][index]["minimum_spending"].string!
						menuList.convFee = json["response"]["data"][index]["conv_fee"].string!
						menuList.deliveryCharge = json["response"]["data"][index]["delivery_charge"].string!
						
						
						menuList.placeId = json["response"]["data"][index]["place_id"].string!
						
						

						
						
						commonForShopAtlast1.append(menuList)
						
					}
				}
				
				
				
			}
		}
		
		task2.resume()
		DispatchQueue.main.async {
			self.performSegue(withIdentifier: "shopconnect", sender: self)

		}
		

		
		
	}
	
       override func viewDidAppear(_ animated: Bool) {
		commonForShopAtlast1.removeAll()
		reloadFunc()
	}
	
	
	func reloadFunc(){
		
		if categoryOfItem.count == 0{
			_ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.reloadFunc), userInfo: nil, repeats: false);
			
		}
	
		myTableView.reloadData()
	}
	
	func getItemForCategory(_ listArrayForItem: [shopMenuItem]) {
		
	
	}
	
	

	
	
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
	
	
	if segue.identifier == "shopconnect" {
		let shopmenu = segue.destination as! ItemsTVC
		
		shopmenu.indexValueReceiver = indexValueSender
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
    }
	

}
