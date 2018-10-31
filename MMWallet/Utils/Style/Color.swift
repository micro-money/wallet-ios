//
//  Color.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

internal typealias Color = UIColor

extension Color {
    enum ComponentsType {

        case cryptoEthereum
        case cryptoBitcoin

        case viewBackground
        case buttonFill
        case buttonTitleNormal
        case buttonTitleDisable
        case button
        case buttonTintSkip
        case buttonTintNext
        
        case tabbarSelected
        case tabbarUnselected

        case buttonAddContact
        case labelAddContactBack

        case buttonMeContact
        case labelMeContactBack
        case buttonNotMeContact
        case labelNotMeContactBack
        case lineContactBack

        case searchBackground

        case keyPad
        case keyPadSelected
        case keyPadText

        case textVersion
        case textSections

        case textFieldBackground
        case textFieldCaret
        case labelPlaceholder
        case textFieldNormalLine
        case textFieldErrorLine
        case textFieldText
        case clearOrangebutton
        case orangebutton

        case resultTabBorder
        case resultTabBackground
        case resultTabLine
        case resultTitleText
        case resultAddressText
        case resultURLText
        case resultURLBackground

        case buttonCurrency
        case buttonCurrencySelected

        case orangeFieldBackground
        
        case labelInfo
        case navigationBarTint
        case navigationItemTint
        case navigationBackground
        case navigationText

        case subNavigationBackground

        case labelDashboardSection

        case labelStatusDone
        case labelStatusCancelled
        case labelStatusPending

        case buttonNewAssetsNext

        case buttonsReceiveInput

        case buttonLogout

        case popBackground
        case popButtonClose
        case popText
        case popInputBackground

        case feesBackground
        case feesTitle
        case feesText
        case feesSelected

        case carbonLine
        case carbonText

        case settingsLine

        case modalArrow
        
        var colorType: ColorType {
            switch self {
            case .cryptoEthereum: return .etherium
            case .cryptoBitcoin: return .bitcoin

            case .viewBackground: return .grayFA
            case .buttonFill: return .primary
            case .buttonTitleNormal: return .white
            case .buttonTitleDisable: return .white_70
            case .button: return .primary
            case .buttonTintSkip: return .gray8E
            case .buttonTintNext: return .primary
                
            case .tabbarSelected: return .primary
            case .tabbarUnselected: return .gray7C

            case .buttonAddContact: return .gray9B
            case .labelAddContactBack: return .grayEFF4

            case .buttonMeContact: return .orangeF0
            case .labelMeContactBack: return .orangeFC

            case .buttonNotMeContact: return .green7A
            case .labelNotMeContactBack: return .greenE4

            case .lineContactBack: return .paleGreyTwo

            case .searchBackground: return .steel_12

            case .buttonCurrency: return .steel
            case .buttonCurrencySelected: return .primary

            case .textVersion: return .grayBD
            case .textSections: return .steel

            case .resultTabBorder: return .grayE8
            case .resultTabBackground: return .grayF4
            case .resultTabLine: return .paleGreyTwo
            case .resultTitleText: return .gray9A
            case .resultAddressText: return .gray3C
            case .resultURLText: return .black_70
            case .resultURLBackground: return .paleGreyTwo

            case .textFieldBackground: return .white
            case .textFieldCaret: return .black
            case .labelPlaceholder: return .gray8E
            case .textFieldNormalLine: return .grayE8
            case .textFieldErrorLine: return .orangeRed
            case .textFieldText: return .black
            case .clearOrangebutton: return .primary
            case .orangebutton: return .primary
            case .keyPad: return .grayE870
            case .keyPadSelected: return .gray8E
            case .keyPadText: return .white
                
            case .labelInfo: return .black
            case .navigationBarTint: return .black
            case .navigationItemTint: return .primary
            case .navigationBackground: return .grayD1F8
            case .navigationText: return .black

            case .subNavigationBackground: return .white

            case .labelDashboardSection: return .gray8E

            case .labelStatusDone: return .greenDone
            case .labelStatusCancelled: return .orangeRed
            case .labelStatusPending: return .steel

            case .buttonNewAssetsNext: return .steel

            case .buttonsReceiveInput: return .steel

            case .buttonLogout: return .orangeRed

            case .popBackground: return .grayFA
            case .popButtonClose: return .gray3C
            case .popText: return .gray3C
            case .popInputBackground: return .grayEFF4

            case .feesBackground: return .paleGreyTwo
            case .feesTitle: return .black
            case .feesText: return .black_50
            case .feesSelected: return .primary

            case .carbonLine: return .paleGreyTwo
            case .carbonText: return .primary

            case .orangeFieldBackground: return .orange11

            case .settingsLine: return .paleGreyTwo

            case .modalArrow: return  .black_30
                
                //            case .textFieldPlaceholderText: return .black
                
            }
        }

        var colorTypeDark: ColorType {
            switch self {
            case .cryptoEthereum: return .etherium
            case .cryptoBitcoin: return .bitcoin

            case .viewBackground: return .dark15
            case .buttonFill: return .primary
            case .buttonTitleNormal: return .white
            case .buttonTitleDisable: return .white_70
            case .button: return .primary
            case .buttonTintSkip: return .gray8E
            case .buttonTintNext: return .primary

            case .tabbarSelected: return .primary
            case .tabbarUnselected: return .gray7C

            case .buttonAddContact: return .gray9B
            case .labelAddContactBack: return .grayEFF4

            case .buttonMeContact: return .orangeF0
            case .labelMeContactBack: return .primary

            case .buttonNotMeContact: return .green7A
            case .labelNotMeContactBack: return .greenE4

            case .lineContactBack: return .dark53

            case .searchBackground: return .steel_12

            case .buttonCurrency: return .dark7B
            case .buttonCurrencySelected: return .primary

            case .resultTabBorder: return .black0C
            case .resultTabBackground: return .dark24
            case .resultTabLine: return .gray5E
            case .resultTitleText: return .dark7B
            case .resultAddressText: return .dark7B
            case .resultURLText: return .white_70
            case .resultURLBackground: return .dark7B_50

            case .textVersion: return .dark7B
            case .textSections: return .dark7B

            case .textFieldBackground: return .dark24
            case .textFieldCaret: return .white
            case .labelPlaceholder: return .color98AAB1
            case .textFieldNormalLine: return .black0C
            case .textFieldErrorLine: return .orangeRed
            case .textFieldText: return .white
            case .clearOrangebutton: return .primary
            case .orangebutton: return .primary

            case .keyPad: return .steel_30
            case .keyPadSelected: return .steel_30
            case .keyPadText: return .white

            case .labelInfo: return .black
            case .navigationBarTint: return .black
            case .navigationItemTint: return .primary
            case .navigationBackground: return .black09
            case .navigationText: return .white

            case .subNavigationBackground: return .dark24

            case .labelDashboardSection: return .gray8E

            case .labelStatusDone: return .greenDone
            case .labelStatusCancelled: return .orangeRed
            case .labelStatusPending: return .steel

            case .buttonNewAssetsNext: return .steel

            case .buttonsReceiveInput: return .steel

            case .buttonLogout: return .orangeRed

            case .popBackground: return .black10
            case .popButtonClose: return .dark7B
            case .popText: return .dark7B
            case .popInputBackground: return .dark24

            case .feesBackground: return .black_20
            case .feesTitle: return .white
            case .feesText: return .color98AAB1
            case .feesSelected: return .primary

            case .carbonLine: return .color465c64
            case .carbonText: return .dark7B

            case .orangeFieldBackground: return .dark24

            case .settingsLine: return .black_40

            case .modalArrow: return  .steel

                    //            case .textFieldPlaceholderText: return .black

            }
        }
    }
    convenience init(componentType: ComponentsType) {
        if DefaultsManager.shared.isDarkTheme != nil && DefaultsManager.shared.isDarkTheme! {
            self.init(componentType.colorTypeDark)
            return
        }
        self.init(componentType.colorType)
    }
}
extension Color {
    enum ColorType: String {
        case etherium = "6F7CBA"
        case bitcoin = "FF991C"
        case gray8E = "8E8E93"
        case primary = "F0830E"
        case grayFA = "FAFAFA"
        case grayE8 = "E8E8E8"
        case grayE870 = "B58E8E93"
        case grayEFF4 = "efeff4"
        case gray9B = "9b9b9b"
        case gray9A = "9a9a9a"
        case gray7C = "7c7c7c"
        case black = "000000"
        case white = "ffffff"
        case white_70 = "a3ffffff" //70%
        case greenDone = "7ab317"
        case steel = "8e8e93"
        case steel_12 = "1e8e8e93" //12%
        case steel_30 = "4c8e8e93" //30%
        case orangeRed = "ff3b30"
        case orangeF0 = "f0830e"
        case orangeFC = "fce6cf"
        case green7A = "7AB317"
        case greenE4 = "e4f0d1"
        case grayBD = "bdbdbd"
        case gray3C = "3c3c3c"
        case grayF4 = "f4f4f5"

        case gray5E = "5e737b"

        case orange11 = "11f0830e"

        case silver = "d1d1d6"

        case grayD1F8 = "d1f8f8f8"

        case colorCCB6C4CA = "CCB6C4CA"
        case color98AAB1 = "98AAB1"
        case dark15 = "15323B"
        case dark24 = "24424d"
        case dark7B = "7b8d94"
        case dark7B_50 = "807b8d94" //50%
        case dark53 = "53676f"
        case paleGreyTwo = "e5e5ea"
        case black0C = "0c303c"
        case black09 = "09262f"
        case black10 = "10282f"
        case black_20 = "33000000" //20%
        case black_40 = "40000000" //25%
        case black_30 = "4c000000" //30%
        case black_50 = "80000000" //50%
        case black_70 = "B2000000" //70%

        case color465c64 = "465c64"
    }
    
    convenience init (_ colorType: ColorType) {
        self.init(hexString: colorType.rawValue)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        // swiftlint:disable identifier_name
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
