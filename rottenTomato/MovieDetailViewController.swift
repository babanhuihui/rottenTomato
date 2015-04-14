//
//  MovieDetailViewController.swift
//  rottenTomato
//
//  Created by Shuhui Qu on 4/9/15.
//  Copyright (c) 2015 Shuhui Qu. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController{//,UIGestureRecognizerDelegate
    
    var movie = NSDictionary()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundView: UIImageView!
    
    @IBOutlet weak var synopsisText: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    internal var tempTitle = ""
    internal var tempSynopsis = ""
    internal var tempImage = UIImage()
    
//    required init(coder aDecoder: NSCoder){
//        super.init(coder: aDecoder)
//    }
//
//    @IBOutlet var hideTap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        hideTap.delegate = self
       
        
        
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews(){
        scrollView.contentSize = CGSizeMake(320, 1000)
        titleLabel.text = movie["title"] as? String
        //        synopsisLabel.text = movie["synopsis"] as? String
        synopsisText.text = movie["synopsis"] as? String
        var url = movie.valueForKeyPath("posters.profile")as? String
        url = url?.stringByReplacingOccurrencesOfString("tmb", withString: "ori", options: NSStringCompareOptions.LiteralSearch, range: nil)
        backgroundView.setImageWithURL(NSURL(string: url!)!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool){
        self.titleLabel.text = tempTitle
        self.synopsisText.text = tempSynopsis
        self.backgroundView.image = tempImage
    }
    @IBAction func onTap(sender: AnyObject) {
        scrollView.hidden = scrollView.hidden ^ true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
