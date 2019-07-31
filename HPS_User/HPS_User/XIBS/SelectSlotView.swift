//
//  SelectSlotView.swift
//  HPS_User
//
//  Created by Vamsi on 30/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit

protocol SelectSlotDelegate {
    func delegateForSelectedSLot(selectedSlot :String ,viewCon:SelectSlotView)
}

class SelectSlotView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var eventsData : EventsData!
    var slotsArray: [String] = []
    var delegate : SelectSlotDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    //MARK:- Update UI
    func updateUI(){
        self.view.layer.cornerRadius = 10
        self.tableView.register(UINib(nibName: "SlotCell", bundle: nil), forCellReuseIdentifier: "SlotCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        if let data = self.eventsData{
            let startDate = data.startsAt!
            let endDate = data.endsAt!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let endingDate = dateFormatter.date(from: endDate)
            let modifiedDate = Calendar.current.date(byAdding: .hour, value: -3, to: endingDate!)!
            print(dateFormatter.string(from: modifiedDate))
            self.timeSlots(startDate, end: dateFormatter.string(from: modifiedDate))
        }
    }
    //MARK:- Converting Time Slots
    func timeSlots(_ start : String , end :String){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let date1 = formatter.date(from: start)
        let date2 = formatter.date(from: end)
        var i = 1
        while true {
            let date = date1?.addingTimeInterval(TimeInterval(i*60*60))
            let string = formatter.string(from: date!)
            if date! >= date2! {
                break;
            }
            i += 1
            slotsArray.append(string)
        }
        print(slotsArray)
    }
    //MARK:- IB Action Outlets
    @IBAction func cancelBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("SlotsCancelClicked"), object: nil)
    }
}
// MARK : - Table View Methods
extension SelectSlotView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slotsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlotCell") as! SlotCell
        cell.dateLbl.text = slotsArray[indexPath.row]
        tableView.rowHeight = 50
        cell.selectionStyle = .default
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SlotCell
        cell.cellSelected(true)
        if delegate != nil{
            self.delegate.delegateForSelectedSLot(selectedSlot: slotsArray[indexPath.row], viewCon: self)
            NotificationCenter.default.post(name: Notification.Name("SlotsCancelClicked"), object: nil)
        }
    }
}
