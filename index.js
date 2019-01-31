
const MoEReactBridge = require('react-native').NativeModules.MoEReactBridge;

var ReactMoE = {

	/**
	 * Tracks the specified event
	 *
	 * @param eventName The action associated with the Event
	 * @param eventAttributes A JSONObject of all the attributes which needs to be
	 * logged.
	 */
	trackEvent: function(eventName,eventAttributes){
		console.log("inside trackEvent");
		MoEReactBridge.trackEvent(eventName,eventAttributes);
	},

	/**
	 * Sets the unique id of the user. Should be set on user login.
	 * @param uniqueID unique id to be set
	 */
	setUserUniqueID: function(uniqueID){
		console.log("inside setUserUniqueID");
		var dict = { "AttributeName": "USER_ATTRIBUTE_UNIQUE_ID", "AttributeValue": uniqueID};
		MoEReactBridge.setUserAttribute(dict);
	},

	/**
	 * Sets the user-name of the user.
	 * @param userName user-name to be set
	 */
	setUserName: function(userName){
		console.log("inside setUserName");
		var dict = { "AttributeName": "USER_ATTRIBUTE_USER_NAME", "AttributeValue": userName};
		MoEReactBridge.setUserAttribute(dict);
	},

	/**
	 * Sets the first name of the user.
	 * @param firstName first name to be set
	 */
	setUserFirstName: function(firstName){
		console.log("inside setUserFirstName");
		var dict = { "AttributeName": "USER_ATTRIBUTE_USER_FIRST_NAME", "AttributeValue": firstName};
		MoEReactBridge.setUserAttribute(dict);
	},

	/**
	 * Sets the last name of the user.
	 * @param lastName last name to be set
	 */
	setUserLastName: function(lastName){
		console.log("inside setUserLastName");
		var dict = { "AttributeName": "USER_ATTRIBUTE_USER_LAST_NAME", "AttributeValue": lastName};
		MoEReactBridge.setUserAttribute(dict);
	},

	/**
	 * Sets the email-id of the user.
	 * @param emailId email-id to be set
	 */
	setUserEmailID: function(emailId){
		console.log("inside setUserEmailID");
		var dict = { "AttributeName": "USER_ATTRIBUTE_USER_EMAIL", "AttributeValue": emailId};
		MoEReactBridge.setUserAttribute(dict);
	},

	/**
	 * Sets the mobile number of the user.
	 * @param mobileNumber mobile number to be set
	 */
	setUserContactNumber: function(mobileNumber){
		console.log("inside setUserContactNumber");
		var dict = { "AttributeName": "USER_ATTRIBUTE_USER_MOBILE", "AttributeValue": mobileNumber};
		MoEReactBridge.setUserAttribute(dict);
	},

	/**
	 * Sets the birthday of the user.
	 *  Format - DD/MM/YYYY
	 * @param birthday birthday to be set
	 */
	setUserBirthday: function(birthday){
		console.log("inside setUserBirthday");
		var dict = { "AttributeName": "USER_ATTRIBUTE_USER_BDAY", "AttributeValue": birthday};
		MoEReactBridge.setUserAttribute(dict);
	},

	/**
	 * Sets the gender of the user.
	 * @param gender gender to be set
	 */
	setUserGender: function(gender){
		console.log("inside setUserGender");
		// might be required for iOS, as they have a constant defined for gender which they send to backend. If required this check should be added in the native modules as it is SDK specific.
		// var gender = userAttributeValue.toLowerCase();
		var dict = { "AttributeName": "USER_ATTRIBUTE_USER_GENDER", "AttributeValue": gender};
		MoEReactBridge.setUserAttribute(dict);
	},

	/**
	 * Sets the location of the user.
	 * @param latValue latitude value of the location
	 * @param longValue longitude value of the location
	 */
	setUserLocation: function(latValue,longValue){
		console.log("inside setUserLocation");
		var dict = {"AttributeName": "USER_ATTRIBUTE_USER_LOCATION", "LatVal" : latValue, "LngVal": longValue};
		MoEReactBridge.setUserAttributeLocation(dict);
	},

	/**
	 * Sets the user attribute name.
	 * @param userAttributeName attribute name
	 * @param userAttributeValue attribute value
	 */
	setUserAttribute:function(userAttributeName,userAttributeValue){
		console.log("inside setUserAttribute");
		var dict = { "AttributeName": userAttributeName, "AttributeValue": userAttributeValue};
		MoEReactBridge.setUserAttribute(dict);
	},

	setUserAttributeLocation:function(userAttributeName,latValue,longValue){
		console.log("inside setUserAttributeLocation");
		var dict = {"AttributeName": userAttributeName, "LatVal" : latValue, "LngVal": longValue};
		MoEReactBridge.setUserAttributeLocation(dict);
	},

	/**
	 * Notifys the SDK that the user has logged out of the app.
	 */
	logout: function(){
		console.log("inside logout");
		MoEReactBridge.logout();
	},

	/**
   	* Set log level for MoEngage SDK's logs
   	* @param logLevel : log Level
   	*/
	setLogLevel:function(logLevel){
		console.log("inside setLogLevel");
		MoEReactBridge.setLogLevel(logLevel);
	},

	/**
 	* Tells the SDK whether this is a migration or a fresh installation.
 	* <b>Not calling this method will STOP execution of INSTALL CAMPAIGNS</b>.
 	* This is solely required for migration to MoEngage Platform
 	*
 	* @param existingUser true if it is an existing user else set false
 	*/
	isExistingUser: function(isExisting){
		console.log("inside isExistingUser");
		MoEReactBridge.isExistingUser(isExisting);
	},

//Methods only for iOS SDK
	
	/**
	* Call this method to set a TimeStamp User Attribute
	* @param userAttributeName : attribute name
	* @param timestampValue : timestamp in epoch format
	*/
	setUserAttributeTimestamp:function(userAttributeName,timestampValue){
		console.log("inside setUserAttributeTimestamp");
		var dict = { "AttributeName": userAttributeName, "TimeStampVal": timestampValue};
		MoEReactBridge.setUserAttributeTimestamp(dict);
	},

	/**
	* Call this method to register for push notification in iOS
	*/
	registerForPush: function(){
		console.log("inside registerForPush");
		MoEReactBridge.registerForPushNotification();
	},

	/**
	* Call this method wherever InApp message has to be shown, if available
	*/
	showInApp: function(){
		console.log("inside showInApp");
		MoEReactBridge.showInApp();
	},

	/**
	* Call this method to disable InApp messages in app.
	*/
	disableInApps:function(){
		console.log("inside disableInApps");
		MoEReactBridge.disableInApps();
	},

	/**
	* Call this method to disable Inbox/ Notification Center feature.
	*/
	disableInbox:function(){
		console.log("inside disableInbox");
		MoEReactBridge.disableInbox();
	}
};

module.exports = ReactMoE;
