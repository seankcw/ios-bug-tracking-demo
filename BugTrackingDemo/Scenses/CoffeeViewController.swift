import UIKit
import SnapKit
import Sentry
import raygun4apple
import Bugsee

class CoffeeViewController: UIViewController {
  
  private lazy var stackView: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.alignment = .center
    view.distribution = .fill
    view.spacing = 20
    return view
  }()
  
  private lazy var commonSectionLabel: UILabel = {
    let view = UILabel()
    view.text = "Common Feature"
    view.font = UIFont.boldSystemFont(ofSize: 14)
    return view
  }()
  
  private lazy var loginButton: UIButton = {
    let view = UIButton(type: .roundedRect)
    view.setTitle("Login as Sean", for: .normal)
    view.addTarget(self, action: #selector(login(sender:)), for: .touchUpInside)
    return view
  }()
  
  private lazy var captureErrorButton: UIButton = {
    let view = UIButton(type: .roundedRect)
    view.setTitle("Capture error", for: .normal)
    view.addTarget(self, action: #selector(captureError(sender:)), for: .touchUpInside)
    return view
  }()
  
  private lazy var captureErrorWithTagHotButton: UIButton = {
    let view = UIButton(type: .roundedRect)
    view.setTitle("Capture error with tag - Hot", for: .normal)
    view.addTarget(self, action: #selector(captureErrorWithTagHot(sender:)), for: .touchUpInside)
    return view
  }()
  
  private lazy var captureErrorWithTagColdButton: UIButton = {
    let view = UIButton(type: .roundedRect)
    view.setTitle("Capture error with tag - Cold", for: .normal)
    view.addTarget(self, action: #selector(captureErrorWithTagCold(sender:)), for: .touchUpInside)
    return view
  }()
  
  private lazy var testBreadcrumbs: UIButton = {
    let view = UIButton(type: .roundedRect)
    view.setTitle("Test breadcrumbs", for: .normal)
    return view
  }()
  
  private lazy var logoutButton: UIButton = {
    let view = UIButton(type: .roundedRect)
    view.setTitle("Logout", for: .normal)
    view.addTarget(self, action: #selector(logout(sender:)), for: .touchUpInside)
    return view
  }()
  
  private lazy var sentrySectionLabel: UILabel = {
    let view = UILabel()
    view.text = "Sentry Feature"
    view.font = UIFont.boldSystemFont(ofSize: 14)
    return view
  }()
  
  private lazy var captureErrorWithFeedbackButton: UIButton = {
    let view = UIButton(type: .roundedRect)
    view.setTitle("Capture error with feedback", for: .normal)
    view.addTarget(self, action: #selector(captureErrorWithFeedback(sender:)), for: .touchUpInside)
    return view
  }()
  
  private lazy var bugseeSectionLabel: UILabel = {
    let view = UILabel()
    view.text = "Bugsee Feature"
    view.font = UIFont.boldSystemFont(ofSize: 14)
    return view
  }()
  
  private lazy var chatWithBugseeButton: UIButton = {
    let view = UIButton(type: .roundedRect)
    view.setTitle("Chat with Bugsee", for: .normal)
    view.addTarget(self, action: #selector(chatWithBugsee(sender:)), for: .touchUpInside)
    return view
  }()
  
  
  private lazy var navigateDetailButton: UIButton = {
    let view = UIButton(type: .roundedRect)
    view.setTitle("Navigate to Detail", for: .normal)
    view.backgroundColor = UIColor.lightGray
    view.addTarget(self, action: #selector(navigateToDetail(sender:)), for: .touchUpInside)
    return view
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.white
    initView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  private func initView() {
    //Init stackview
    self.view.addSubview(stackView)
    stackView.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(self.view.snp.topMargin).offset(20)
      make.leading.equalTo(self.view).offset(20)
      make.trailing.equalTo(self.view).offset(-20)
    }
    
    //Init common section
    stackView.addArrangedSubview(commonSectionLabel)
    stackView.addArrangedSubview(loginButton)
    stackView.addArrangedSubview(captureErrorButton)
    stackView.addArrangedSubview(captureErrorWithTagHotButton)
    stackView.addArrangedSubview(captureErrorWithTagColdButton)
    stackView.addArrangedSubview(logoutButton)
    
    stackView.addArrangedSubview(sentrySectionLabel)
    stackView.addArrangedSubview(captureErrorWithFeedbackButton)
    
    stackView.addArrangedSubview(bugseeSectionLabel)
    stackView.addArrangedSubview(chatWithBugseeButton)
    
    //Init navigation button to detail page
    if self.navigationController?.viewControllers.count == 1 {
      self.view.addSubview(navigateDetailButton)
      navigateDetailButton.snp.makeConstraints { (make) in
        make.bottom.equalTo(self.view).offset(-20)
        make.leading.equalTo(self.view).offset(20)
        make.trailing.equalTo(self.view).offset(-20)
      }
    }
  }
  
  @objc
  func login(sender: UIButton){
    func loginSentryUser(_ user: DummyUser) {
      let sentryUser = User()
      sentryUser.username = user.username
      sentryUser.email = user.email
      SentrySDK.setUser(sentryUser)
    }
    
    func loginRaygunUser(_ user: DummyUser) {
      let userInformation = RaygunUserInformation(identifier: user.username,
                                                  email: user.email,
                                                  fullName: "\(user.firstName) \(user.lastName)",
                                                  firstName: user.firstName)
      RaygunClient.sharedInstance().userInformation = userInformation
    }
    
    func loginBugseeUser(_ user: DummyUser) {
      Bugsee.setEmail(user.email)
      Bugsee.setAttribute("username", value: user.username)
      Bugsee.setAttribute("name", value: "\(user.firstName) \(user.lastName)")
    }
    
    let dummyUser = DummyUser()
    
    loginSentryUser(dummyUser)
    loginRaygunUser(dummyUser)
    loginBugseeUser(dummyUser)
  }
  
  @objc
  func logout(sender: UIButton){
    SentrySDK.setUser(nil)
    RaygunClient.sharedInstance().userInformation = nil
    Bugsee.clearEmail()
    Bugsee.clearAllAttribute()
  }
  
  @objc
  func navigateToDetail(sender: UIButton) {
    self.navigationController?.pushViewController(CoffeeViewController(), animated: true)
  }
  
  @objc
  func captureError(sender:UIButton) {
    do {
      try RandomErrorGenerator.generate()
    } catch {
      SentrySDK.capture(error: error) { (scope) in
        //            scope.setTag(value: "value", key: "myTag")
      }
      
      RaygunClient.sharedInstance().send(error: error, tags: nil, customData: nil)
      
      Bugsee.logError(error: error, labels: [])
    }
  }
  
  @objc
  func captureErrorWithTagHot(sender:UIButton) {
    do {
      try RandomErrorGenerator.generate()
    } catch {
      SentrySDK.capture(error: error) { (scope) in
        scope.setTag(value: "Hot", key: "coffee.type")
      }
      
      RaygunClient.sharedInstance().send(error: error, tags: ["Hot"], customData: nil)
      
      Bugsee.logError(error: error, labels: ["Hot"])
    }
  }

  @objc
  func captureErrorWithTagCold(sender:UIButton) {
    do {
      try RandomErrorGenerator.generate()
    } catch {
      SentrySDK.capture(error: error) { (scope) in
        scope.setTag(value: "Cold", key: "coffee.type")
      }
      
      RaygunClient.sharedInstance().send(error: error, tags: ["Cold"], customData: nil)
      
      Bugsee.logError(error: error, labels: ["Cold"])
    }
  }
  
  
  //MARK: Sentry
  @objc
  func captureErrorWithFeedback(sender:UIButton) {
    do {
      try RandomErrorGenerator.generate()
    } catch {
      let user = DummyUser()
      let eventId = SentrySDK.capture(error: error)
      let userFeedback = UserFeedback(eventId: eventId)
      userFeedback.comments = "It broke."
      userFeedback.email = user.email
      userFeedback.name = user.username
      SentrySDK.capture(userFeedback: userFeedback)
    }
  }
  
  //MARK: Bugsee
  @objc
  func chatWithBugsee(sender: UIButton) {
    Bugsee.showFeedbackController()
  }
  
  
}

