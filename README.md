# wallet-iOS-app

# Building

## Install Cocoapods
`sudo gem install cocoapods`

## Install Dependencies
`pod install`

## Add production Config file

    #create a directory named Config in the root
    mkdir Config

    #create the config file
    vi Production.xcconfig

    #write the following in Production.xcconfig
    
    SERVER_URL = subdomain.yourdomain.com

    GOOGLE_CLIENT_ID = com.googleusercontent.apps.X

    FACEBOOK_APP_ID = 000000000000000

    KAKAO_APP_KEY = 00000000000000000000000000000000

    WEIBO_APP_ID = 0000000000

    WEIBO_SECRET = 00000000000000000000000000000000

    LINKEDIN_KEY = 00000000000000
    LINKEDIN_SECRET = 00000000000000

    TWITTER_APP_ID = 0000000000
    TWITTER_SECRET = 0000000000

    FABRIC_API_KEY = 0000000000000000000000000000000000000000
    FABRIC_SEC_KEY= 0000000000000000000000000000000000000000000000000000000000000000

    DEMO_LOGIN = demo@email.com

    KEYCHAIN_ID = com.yourdomain.subdomain.keychain
    
## Open the project in Xcode

    open MMWallet.xcworkspace

## Build the project

    cmd-r

