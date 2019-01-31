# React Native MoEngage 

## SDK Installation
Install MoEngage's React Native plugin using the npm package manager. And then link your native dependencies :
```
$ npm install react-native-moengage
$ react-native link
```

After installing the plugin lets move on to platform specific configuration.

### Android
In android/settings.gradle add the following
```
include ':react-native-moengage'
project(':react-native-moengage').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-moengage/android')
```

In android/app/build.gradle add the following
```
 dependencies {
    ...

    compile project(':react-native-moengage')
}
```
Add the MoEngage React Package in the Application class's getPackages() Also enable auto integration in the onCreate()

```
 public class MainApplication extends Application implements ReactApplication {

  private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {
    @Override
    protected boolean getUseDeveloperSupport() {
      return BuildConfig.DEBUG;
    }

    @Override
    protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
          new MainReactPackage(), new MoEReactPackage());
    }
  };

  @Override public void onCreate() {
    super.onCreate();
    MoEHelper.getInstance(getApplicationContext()).autoIntegrate(this);
  }

  @Override
  public ReactNativeHost getReactNativeHost() {
      return mReactNativeHost;
  }
}
```
In case you are facing issues with the import add the below import statement in your java file.

```
 import com.moengage.react.MoEReactPackage;
```
 
### iOS
Install the native MoEngage iOS SDK by using CocoaPods as described here: https://docs.moengage.com/docs/sdk-integration#section-integration-through-cocoapods

NOTE :
Incase if you get errors in the test targets of the project, go to build settings of the test target and add -lc++ flag to Other Linker Flags as shown below :

![Build Settings](https://user-images.githubusercontent.com/15011722/31492360-4ca64ff8-af68-11e7-92f6-4743121b41d8.png)

Thats it!! SDK is successfully installed in the project, and ready to use.

For more info on how to use react-native-moengage, refer to our developer docs: https://docs.moengage.com/docs/sdk-integration-2
