//
//  GDLanguageManager.swift
//  zjlao
//
//  Created by WY on 16/10/31.
//  Copyright © 2019年 WY. All rights reserved.
//

import UIKit

//MARK: 语言包名
let LFollowSystemLanguage = "SystemLanguage"//"Localizable" 语言代表跟随系统
let LEnglish = "English"
let LChinese = "Simplified"
let LJapanese = "Japanese"
let LTraditionsal = "Traditional"
let LVietnamese = "Vietnamese"
let LThai = "Thai"
let LKorean = "Korean"
let LMalay = "Malay"
let LRussian = "Russian"
//MARK: 从语言包里取值时用的key
let LLanguageID = "languageID"//
//提示语
let LCurrentLanguageIs  =  "currentLanguageIs"// = "当前语言已经是";
let  LLanguageChangeing  = "languageChangeing"// = "语言切换中 请稍后...";
let LConfirm = "confirm" //= "确定";
let LCancel = "cancel" //= "取消";
let LLanguageTableName = "LanguageTableName"
let LApplyAfterRestart = "applyAfterRestart"

class DDLanguageManager: NSObject {
    ///国家码
    class var countryCode : String{
        get {
            return DDStorgeManager.share.string(forKey: "COUNTRYCODE") ?? DDLanguageManager.text("country_code")
        }
        set{
            DDStorgeManager.share.set(countryCode, forKey: "COUNTRYCODE")
        }
    }
    ///语言码
    class var languageIdentifier : String{
        return DDLanguageManager.text("language_identifier")
    }
//MARK:获取偏好设置里现存的当前语言包名
   class var LanguageTableName : String?  {//当前语言包名(是LocalizableCH , 还是 LoaclizableEN)
        //    UserDefaults.standard.set("LocalizableEN", forKey: "LanguageTableName")
        guard let LanguageTableNameAny = DDStorgeManager.standard.value(forKey: LLanguageTableName) else{return LFollowSystemLanguage}//如果取不到就返回跟随系统的语言table名
        guard let LanguageTableName  = LanguageTableNameAny as? String else {return LFollowSystemLanguage}//如果取不到就返回跟随系统的语言table名
//        mylog("当前语言为\(LanguageTableName)")
        return LanguageTableName//正常返回保存到偏好设置的语言包名
    }

//MARK:通过国际化的方式获取对应key值的字符串
   class func text(_ byKey : String) -> String {
            return   NSLocalizedString(byKey, tableName: LanguageTableName, bundle: Bundle.main, value: "nil", comment: "")

    }
    
    
//MARK:////////////////////////////////////////////更改语言相关//////////////////////////////////////////////////////
    
    

    class  func performChangeLanguage(targetLanguage : String)  {
        
        
        let noticStr_currentLanguageIs = NSLocalizedString(LCurrentLanguageIs, tableName: LanguageTableName, bundle: Bundle.main, value:"", comment: "") // 提示语 中文的话 :@"当前语言是"   , 英文的花 : @"currentLanguageIs" (提示语也要国际化)
        let noticeStr_changeing = NSLocalizedString(LLanguageChangeing, tableName: LanguageTableName, bundle: Bundle.main, value:"", comment: "") // 提示语 中文的话 @"语言更改中"  英文的话 @"languageChangeing" (提示语也要国际化)
        
        if targetLanguage == LanguageTableName && targetLanguage == LFollowSystemLanguage {//切换前后语言相同 , 除了提示之外不做任何变化
            GDAlertView.alert(self.text(LApplyAfterRestart) , image: nil, time: 2, complateBlock: nil)
        }else if targetLanguage == LanguageTableName {//切换前后语言相同 , 除了提示之外不做任何变化
            GDAlertView.alert("\(noticStr_currentLanguageIs)\(DDLanguageManager.text(LLanguageID) )", image: nil, time: 2, complateBlock: nil)
            
        }else if (targetLanguage == LFollowSystemLanguage){//由自定义语言切换为跟随系统语言
            if DDLanguageManager.text(LLanguageID)  ==  DDLanguageManager.gotcurrentSystemLanguage() {//当切换前的自定义语言跟当前系统语言一样时 ,只保存 ,不重新切换 (如何获取系统语言??)
                GDAlertView.alert("当前语言已经是\(targetLanguage)", image: nil, time: 2, complateBlock: nil)
                DDStorgeManager.standard.set(LFollowSystemLanguage, forKey: LLanguageTableName)
            }else{//否则即保存又重新切换
                GDAlertView.alert(self.text(LApplyAfterRestart), image: nil, time: 2, complateBlock: nil)//保存前提示
                DDStorgeManager.standard.set(LFollowSystemLanguage, forKey: LLanguageTableName)
            }
        }else{//切换为自定义语言
            let oldLanguageName = LanguageTableName
            DDStorgeManager.standard.set(targetLanguage, forKey: LLanguageTableName)
            //            if  GDLanguageManager.titleByKey(key: LLanguageID)  != nil {
            if DDLanguageManager.text(LLanguageID) == "languageID"  {//gotTitleStr(key:)这个方法如果找不到键所对应的值 , 就把键返回,同时也说明本地没有相应的语言包
                GDAlertView.alert("没有相应的语言包", image: nil, time: 2, complateBlock: nil)
                DDStorgeManager.standard.set(oldLanguageName, forKey: LLanguageTableName)//顺便改回原来的语言
            }else{
                DDStorgeManager.standard.set(targetLanguage, forKey: LLanguageTableName)

            }
        }
        
    }

    
/*
   class  func performChangeLanguage(targetLanguage : String)  {
        
        
        let noticStr_currentLanguageIs = NSLocalizedString(LCurrentLanguageIs, tableName: LanguageTableName, bundle: Bundle.main, value:"", comment: "") // 提示语 中文的话 :@"当前语言是"   , 英文的花 : @"currentLanguageIs" (提示语也要国际化)
        let noticeStr_changeing = NSLocalizedString(LLanguageChangeing, tableName: LanguageTableName, bundle: Bundle.main, value:"", comment: "") // 提示语 中文的话 @"语言更改中"  英文的话 @"languageChangeing" (提示语也要国际化)
    
        if targetLanguage == LanguageTableName && targetLanguage == LFollowSystemLanguage {//切换前后语言相同 , 除了提示之外不做任何变化
            GDAlertView.alert(self.titleByKey(key: LApplyAfterRestart), image: nil, time: 2, complateBlock: nil)
        }else if targetLanguage == LanguageTableName {//切换前后语言相同 , 除了提示之外不做任何变化
            GDAlertView.alert("\(noticStr_currentLanguageIs)\(GDLanguageManager.titleByKey(key: LLanguageID))", image: nil, time: 2, complateBlock: nil)
            
        }else if (targetLanguage == LFollowSystemLanguage){//由自定义语言切换为跟随系统语言
            if GDLanguageManager.titleByKey(key: LLanguageID) ==  GDLanguageManager.gotcurrentSystemLanguage() {//当切换前的自定义语言跟当前系统语言一样时 ,只保存 ,不重新切换 (如何获取系统语言??)
                GDAlertView.alert("当前语言已经是\(targetLanguage)", image: nil, time: 2, complateBlock: nil)
                GDStorgeManager.standard.set(LFollowSystemLanguage, forKey: LLanguageTableName)
            }else{//否则即保存又重新切换
                GDAlertView.alert(self.titleByKey(key: LApplyAfterRestart), image: nil, time: 2, complateBlock: nil)//保存前提示
                GDStorgeManager.standard.set(LFollowSystemLanguage, forKey: LLanguageTableName)
            }
        }else{//切换为自定义语言
            let oldLanguageName = LanguageTableName
            GDStorgeManager.standard.set(targetLanguage, forKey: LLanguageTableName)
//            if  GDLanguageManager.titleByKey(key: LLanguageID)  != nil {
                if GDLanguageManager.titleByKey(key: LLanguageID) == "languageID"  {//gotTitleStr(key:)这个方法如果找不到键所对应的值 , 就把键返回,同时也说明本地没有相应的语言包
                    GDAlertView.alert("没有相应的语言包", image: nil, time: 2, complateBlock: nil)
                    GDStorgeManager.standard.set(oldLanguageName, forKey: LLanguageTableName)//顺便改回原来的语言
                }else{
                    GDStorgeManager.standard.set(targetLanguage, forKey: LLanguageTableName)
                    //                     (UIApplication.shared.delegate as? AppDelegate)?.resetKeyVC()
//                    (UIApplication.shared.delegate as? AppDelegate)?.showNotic(autoHide: false, showStr:"\(noticeStr_changeing)" )
                    KeyVC.share.restartAfterChangedLanguage()
                }
//            }else{
//                GDAlertView.alert("没有相应的语言包", image: nil, time: 2, complateBlock: nil)
//                UserDefaults.standard.set(oldLanguageName, forKey: "LanguageTableName")//顺便改回原来的语言
//            }
            
        }
        
    }
*/
    ////MARK:设置语言的方法
    //func setsystemLnaguage(targetLanguageTableName : String) -> Bool {//changeLanguage1
    //    if targetLanguageTableName == LanguageTableName {//切换前后语言相同 , 除了提示之外不做任何变化
    //        alert("当前语言已经是\(targetLanguageTableName)", time: 2, complateBlock: nil)
    //
    //    }else if (targetLanguageTableName == FollowSystemLanguage){//由自定义语言切换为跟随系统语言
    //        if targetLanguageTableName ==  gotcurrentSystemLanguage() {//当切换前的自定义语言跟当前系统语言一样时 ,只保存 ,不重新切换 (如何获取系统语言??)
    //             UserDefaults.standard.set(FollowSystemLanguage, forKey: "LanguageTableName")
    //        }else{//否则即保存又重新切换
    //            UserDefaults.standard.set(FollowSystemLanguage, forKey: "LanguageTableName")
    //            performChangeTheLanguage(targetLanguageTableName:targetLanguageTableName)
    //        }
    //    }else{
    //         UserDefaults.standard.set(targetLanguageTableName, forKey: "LanguageTableName")
    //        performChangeTheLanguage(targetLanguageTableName:targetLanguageTableName)
    //    }
    //    return true
    //}
    ////MARK:执行更改语言操作
    //func performChangeTheLanguage(targetLanguageTableName:String) {//changeLanguage2
    //    (UIApplication.shared.delegate as? AppDelegate)?.performChangeLanguage(targetLanguage: targetLanguageTableName)
    ////    (UIApplication.shared.delegate as? AppDelegate)?.resetKeyVC()
    //}
    //iOS 获取当前手机系统语言
    
    /**
     *得到本机现在用的语言
     * en-CN 或en  英文  zh-Hans-CN或zh-Hans  简体中文   zh-Hant-CN或zh-Hant  繁体中文    ja-CN或ja  日本  ......
     */
// 获取当前设备支持语言数组
    let languagearr = NSLocale.availableLocaleIdentifiers
    /*
     (
     ["eu", "hr_BA", "en_CM", "en_BI", "rw_RW", "ast", "en_SZ", "he_IL", "ar", "uz_Arab", "en_PN", "as", "en_NF", "ks_IN", "rwk_TZ", "zh_Hant_TW", "en_CN", "gsw_LI", "ta_IN", "th_TH", "es_EA", "fr_GF", "ar_001", "en_RW", "tr_TR", "de_CH", "ee_TG", "en_NG", "fr_TG", "az", "fr_SC", "es_HN", "en_AG", "ru_KZ", "gsw", "dyo", "so_ET", "zh_Hant_MO", "de_BE", "nus_SS", "km_KH", "my_MM", "mgh_MZ", "ee_GH", "es_EC", "kw_GB", "rm_CH", "en_ME", "nyn", "mk_MK", "bs_Cyrl_BA", "ar_MR", "en_BM", "ms_Arab", "en_AI", "gl_ES", "en_PR", "ff_CM", "ne_IN", "or_IN", "khq_ML", "en_MG", "pt_TL", "en_LC", "ta_SG", "iu_CA", "jmc_TZ", "om_ET", "lv_LV", "es_US", "en_PT", "vai_Latn_LR", "yue_HK", "en_NL", "to_TO", "cgg_UG", "ta", "en_MH", "zu_ZA", "shi_Latn_MA", "brx_IN", "ar_KM", "en_AL", "te", "chr_US", "yo_BJ", "fr_VU", "pa", "tg", "kea", "ksh_DE", "sw_CD", "te_IN", "fr_RE", "th", "ur_IN", "yo_NG", "ti", "guz_KE", "tk", "kl_GL", "ksf_CM", "mua_CM", "lag_TZ", "lb", "fr_TN", "es_PA", "pl_PL", "to", "hi_IN", "dje_NE", "es_GQ", "en_BR", "kok_IN", "pl", "fr_GN", "bem", "ha", "ckb", "lg", "tr", "en_PW", "en_NO", "nyn_UG", "sr_Latn_RS", "gsw_FR", "pa_Guru", "he", "sn_ZW", "qu_BO", "lu_CD", "mgo_CM", "ps_AF", "en_BS", "da", "ps", "ln", "pt", "hi", "lo", "ebu", "de", "gu_IN", "seh", "en_CX", "en_ZM", "fr_HT", "fr_GP", "lt", "lu", "ln_CD", "vai_Latn", "el_GR", "lv", "en_KE", "sbp", "hr", "en_CY", "es_GT", "twq_NE", "zh_Hant_HK", "kln_KE", "fr_GQ", "chr", "hu", "es_UY", "fr_CA", "ms_BN", "en_NR", "mer", "shi", "es_PE", "fr_SN", "bez", "sw_TZ", "wae_CH", "kkj", "hy", "teo_KE", "en_CZ", "dz_BT", "teo", "ar_JO", "mer_KE", "khq", "ln_CF", "nn_NO", "en_MO", "ar_TD", "dz", "ses", "en_BW", "en_AS", "ar_IL", "nnh", "bo_CN", "teo_UG", "hy_AM", "ln_CG", "sr_Latn_BA", "en_MP", "ksb_TZ", "ar_SA", "smn_FI", "ar_LY", "en_AT", "so_KE", "fr_CD", "af_NA", "en_NU", "es_PH", "en_KI", "en_JE", "lkt", "en_AU", "fa_IR", "uz_Latn_UZ", "zh_Hans_CN", "ewo_CM", "fr_PF", "ca_IT", "en_BZ", "ar_KW", "pt_GW", "fr_FR", "am_ET", "en_VC", "fr_DJ", "fr_CF", "es_SV", "en_MS", "pt_ST", "ar_SD", "luy_KE", "gd_GB", "de_LI", "fr_CG", "ckb_IQ", "zh_Hans_SG", "en_MT", "ha_NE", "ewo", "af_ZA", "os_GE", "om_KE", "nl_SR", "es_ES", "es_DO", "ar_IQ", "fr_CH", "nnh_CM", "es_419", "en_MU", "en_US_POSIX", "yav_CM", "luo_KE", "dua_CM", "et_EE", "en_IE", "ak_GH", "rwk", "es_CL", "kea_CV", "fr_CI", "ckb_IR", "fr_BE", "se", "en_NZ", "en_MV", "en_LR", "ha_NG", "en_KN", "nb_SJ", "sg", "sr_Cyrl_RS", "ru_RU", "en_ZW", "sv_AX", "si", "ga_IE", "en_VG", "ff_MR", "sk", "ky_KG", "agq_CM", "mzn", "fr_BF", "sl", "en_MW", "mr_IN", "az_Latn", "en_LS", "de_AT", "ka", "naq_NA", "sn", "sr_Latn_ME", "fr_NC", "so", "is_IS", "twq", "ig_NG", "sq", "fo_FO", "sr", "tzm", "ga", "om", "en_LT", "bas_CM", "se_NO", "ki", "nl_BE", "ar_QA", "gd", "sv", "kk", "sw", "es_CO", "az_Latn_AZ", "rn_BI", "or", "kl", "ca", "en_VI", "km", "os", "en_MY", "kn", "en_LU", "fr_SY", "ar_TN", "en_JM", "fr_PM", "ko", "fr_NE", "ce", "fr_MA", "gl", "ru_MD", "saq_KE", "ks", "fr_CM", "lb_LU", "gv_IM", "fr_BI", "en_LV", "en_KR", "es_NI", "en_GB", "kw", "nl_SX", "dav_KE", "tr_CY", "ky", "en_UG", "en_TC", "ar_EG", "fr_BJ", "gu", "es_PR", "fr_RW", "sr_Cyrl_BA", "lrc_IQ", "gv", "fr_MC", "cs", "bez_TZ", "es_CR", "asa_TZ", "ar_EH", "fo_DK", "ms_Arab_BN", "en_JP", "sbp_TZ", "en_IL", "lt_LT", "mfe", "en_GD", "cy", "ug_CN", "ca_FR", "es_BO", "fr_BL", "bn_IN", "uz_Cyrl_UZ", "lrc_IR", "az_Cyrl", "en_IM", "sw_KE", "en_SB", "pa_Arab", "ur_PK", "haw_US", "ar_SO", "en_IN", "fil", "fr_MF", "en_WS", "es_CU", "ja_JP", "fy_NL", "en_SC", "en_IO", "pt_PT", "en_HK", "en_GG", "fr_MG", "de_LU", "tzm_MA", "en_SD", "shi_Tfng", "ln_AO", "as_IN", "en_GH", "ms_MY", "ro_RO", "jgo_CM", "dua", "en_UM", "en_SE", "kn_IN", "en_KY", "vun_TZ", "kln", "lrc", "en_GI", "ca_ES", "rof", "pt_CV", "kok", "pt_BR", "ar_DJ", "yi_001", "fi_FI", "zh", "es_PY", "ar_SS", "mua", "sr_Cyrl_ME", "vai_Vaii_LR", "en_001", "nl_NL", "en_TK", "si_LK", "en_SG", "sv_SE", "fr_DZ", "ca_AD", "pt_AO", "vi", "xog_UG", "xog", "en_IS", "nb", "seh_MZ", "ars", "es_AR", "sk_SK", "en_SH", "ti_ER", "nd", "az_Cyrl_AZ", "zu", "ne", "nd_ZW", "el_CY", "en_IT", "nl_BQ", "da_GL", "ja", "rm", "fr_ML", "rn", "en_VU", "rof_TZ", "ro", "ebu_KE", "ru_KG", "en_SI", "sg_CF", "mfe_MU", "nl", "brx", "bs_Latn", "fa", "zgh_MA", "en_GM", "shi_Latn", "en_FI", "nn", "en_EE", "ru", "yue", "kam_KE", "fur", "vai_Vaii", "ar_ER", "rw", "ti_ET", "ff", "luo", "fa_AF", "nl_CW", "en_HR", "en_FJ", "fi", "pt_MO", "be", "en_US", "en_TO", "en_SK", "bg", "ru_BY", "it_IT", "ml_IN", "gsw_CH", "qu_EC", "fo", "sv_FI", "en_FK", "nus", "ta_LK", "vun", "sr_Latn", "fr", "en_SL", "bm", "ar_BH", "guz", "bn", "bo", "ar_SY", "lo_LA", "ne_NP", "uz_Latn", "be_BY", "es_IC", "sr_Latn_XK", "ar_MA", "pa_Guru_IN", "br", "luy", "kde_TZ", "bs", "fy", "fur_IT", "hu_HU", "ar_AE", "en_HU", "sah_RU", "zh_Hans", "en_FM", "sq_AL", "ko_KP", "en_150", "en_DE", "ce_RU", "en_CA", "hsb_DE", "fr_MQ", "en_TR", "ro_MD", "es_VE", "tg_TJ", "fr_WF", "mt_MT", "kab", "nmg_CM", "ms_SG", "en_GR", "ru_UA", "fr_MR", "zh_Hans_MO", "ff_GN", "bs_Cyrl", "sw_UG", "ko_KR", "en_DG", "bo_IN", "en_CC", "shi_Tfng_MA", "lag", "it_SM", "os_RU", "en_TT", "ms_Arab_MY", "sq_MK", "bem_ZM", "kde", "ar_OM", "kk_KZ", "cgg", "bas", "kam", "wae", "es_MX", "sah", "zh_Hant", "en_GU", "fr_MU", "fr_KM", "ar_LB", "en_BA", "en_TV", "sr_Cyrl", "mzn_IR", "dje", "kab_DZ", "fil_PH", "se_SE", "vai", "hr_HR", "bs_Latn_BA", "nl_AW", "dav", "so_SO", "ar_PS", "en_FR", "uz_Cyrl", "ff_SN", "en_BB", "ki_KE", "en_TW", "naq", "en_SS", "mg_MG", "mas_KE", "en_RO", "en_PG", "mgh", "dyo_SN", "mas", "agq", "bn_BD", "haw", "yi", "nb_NO", "da_DK", "en_DK", "saq", "ug", "cy_GB", "fr_YT", "jmc", "ses_ML", "en_PH", "de_DE", "ar_YE", "bm_ML", "yo", "lkt_US", "uz_Arab_AF", "jgo", "sl_SI", "uk", "en_CH", "asa", "lg_UG", "qu_PE", "mgo", "id_ID", "en_NA", "en_GY", "zgh", "pt_MZ", "fr_LU", "ta_MY", "mas_TZ", "en_DM", "dsb", "mg", "en_BE", "ur", "fr_GA", "ka_GE", "nmg", "en_TZ", "eu_ES", "ar_DZ", "id", "so_DJ", "hsb", "yav", "mk", "pa_Arab_PK", "ml", "en_ER", "ig", "se_FI", "mn", "ksb", "uz", "vi_VN", "ii", "qu", "en_PK", "ee", "ast_ES", "mr", "ms", "en_ES", "ha_GH", "it_CH", "sq_XK", "mt", "en_CK", "br_FR", "tk_TM", "sr_Cyrl_XK", "ksf", "en_SX", "bg_BG", "en_PL", "af", "el", "cs_CZ", "fr_TD", "zh_Hans_HK", "is", "ksh", "my", "mn_MN", "en", "it", "dsb_DE", "ii_CN", "smn", "iu", "eo", "en_ZA", "en_AD", "ak", "en_RU", "kkj_CM", "am", "es", "et", "uk_UA"]
     )
     */
    //MARK:获取手机当前系统语言
    class  func gotcurrentSystemLanguage() -> String{
        let languages = DDStorgeManager.standard.object(forKey: "AppleLanguages")//同NSLocale.preferredLanguages
        guard  let languagesAny = languages else {return   "" }
        guard let languagesArr = languagesAny as? [AnyObject] else { return "" }
        let systemLanguage = languagesArr[0]
        guard let systemLanguageIdentifier  = systemLanguage as? String else { return "" }
        return systemLanguageIdentifier
    }
    //:在当前语言环境下 , 显示目标languageIdentifier 对应的字符串
    //(参数可通过调用gotcurrentSystemLanguage()方法来获取)
    class func showLanguageString(languageIdendifier : String = "zh-Hans-CN") -> (localeScriptCode:String? , localeLanguageCode:String? ,country:String? ) {
        let currentLocal = NSLocale.current//以当前语言形式形式展示
        let dict = NSLocale.components(fromLocaleIdentifier: languageIdendifier)//要展示的内容
        let localeScriptCode = currentLocal.localizedString(forScriptCode:dict["kCFLocaleScriptCodeKey"] ?? "" )//精确语言 , 如简体中文 , 繁体中文
        let localeLanguageCode = currentLocal.localizedString(forLanguageCode:dict["kCFLocaleLanguageCodeKey"] ?? "" )//语言总称  ,  如中文 (包括简体中文 和 繁体中文)
        let country = currentLocal.localizedString(forRegionCode: dict["kCFLocaleCountryCodeKey"] ?? "")//国家
//        mylog("\(localeScriptCode) || \(localeLanguageCode) || \(country)")
        return (localeScriptCode , localeLanguageCode ,country )
        //LocaleScriptCode != nil ? LocaleScriptCode! : (LocaleLanguageCode ?? "")
    }
    //英语环境下的打印
    /**
     👉[108]ChooseLanguageVC.swift <--> sureClick(sender:)
     Optional(<__NSCFArray 0x60000009c0c0>(
     en-US,
     zh-Hans-US,
     en
     )
     )
     👉[109]ChooseLanguageVC.swift <--> sureClick(sender:)
     en-US
     */
    //简体中文环境下的打印
    /**
     👉[108]ChooseLanguageVC.swift <--> sureClick(sender:)
     Optional(<__NSCFArray 0x60800009a680>(
     zh-Hans-US,
     en-US,
     en
     )
     )
     👉[109]ChooseLanguageVC.swift <--> sureClick(sender:)
     zh-Hans-US
     */
    
    //日语环境下的打印
    /**
    👉[108]ChooseLanguageVC.swift <--> sureClick(sender:)
    Optional(<__NSCFArray 0x6000000966c0>(
    ja-US,
    zh-Hans-US,
    en-US,
    en
    )
    )
    👉[109]ChooseLanguageVC.swift <--> sureClick(sender:)
    ja-US
    */
    
    //func performChangeLanguage(targetLanguage : String)  {
    //    let noticStr_currentLanguageIs = NSLocalizedString("currentLanguageIs", tableName: LanguageTableName, bundle: Bundle.main, value:"", comment: "") // 提示语 中文的话 :@"当前语言是"   , 英文的花 : @"currentLanguageIs" (提示语也要国际化)
    //    let noticeStr_changeing = NSLocalizedString("languageChangeing", tableName: LanguageTableName, bundle: Bundle.main, value:"", comment: "") // 提示语 中文的话 @"语言更改中"  英文的话 @"languageChangeing" (提示语也要国际化)
    //
    //    if let currentLanguage = followSystemLanguage {
    //
    //    } if let currentLanguage = LanguageTableName  {//首先取出当前语言包的文件名
    //
    //        if currentLanguage == targetLanguage {
    //            self.showNotic(autoHide: true, showStr:"\(noticStr_currentLanguageIs)\(targetLanguage)" )
    //            //                alert("\(noticStr_currentLanguageIs)\(targetLanguage)", time: 2)
    //        }else{
    //            UserDefaults.standard.set(targetLanguage, forKey: "LanguageTableName")
    //
    //            self.resetKeyVC()
    //            //                alert("\(noticeStr_changeing)", time: 3)
    //            self.showNotic(autoHide: false, showStr:"\(noticeStr_changeing)" )
    //        }
    //    }else{//如果取出的是nil(第一次取的时候)
    //
    //        UserDefaults.standard.set(targetLanguage, forKey: "LanguageTableName")//把第一次的语言包名存起来
    //
    //        self.resetKeyVC()
    //        //            alert("\(noticeStr_changeing)", time: 3)
    //        self.showNotic(autoHide: false, showStr:"\(noticeStr_changeing)")
    //    }
    //
    //
    //
    //
    //    //        if let currentLanguage = LanguageTableName  {//首先取出当前语言包的文件名
    //    //
    //    //            if currentLanguage == targetLanguage {
    //    //                self.showNotic(autoHide: true, showStr:"\(noticStr_currentLanguageIs)\(targetLanguage)" )
    //    //                //                alert("\(noticStr_currentLanguageIs)\(targetLanguage)", time: 2)
    //    //            }else{
    //    //                UserDefaults.standard.set(targetLanguage, forKey: "LanguageTableName")
    //    //
    //    //                self.resetKeyVC()
    //    //                //                alert("\(noticeStr_changeing)", time: 3)
    //    //                self.showNotic(autoHide: false, showStr:"\(noticeStr_changeing)" )
    //    //            }
    //    //        }else{//如果取出的是nil(第一次取的时候)
    //    //
    //    //            UserDefaults.standard.set(targetLanguage, forKey: "LanguageTableName")//把第一次的语言包名存起来
    //    //
    //    //            self.resetKeyVC()
    //    //            //            alert("\(noticeStr_changeing)", time: 3)
    //    //            self.showNotic(autoHide: false, showStr:"\(noticeStr_changeing)")
    //    //        }
    //}
    
    
    
    
    
}
/***
 af    南非语
 af-ZA    南非语
 ar    阿拉伯语
 ar-AE    阿拉伯语(阿联酋)
 ar-BH    阿拉伯语(巴林)
 ar-DZ    阿拉伯语(阿尔及利亚)
 ar-EG    阿拉伯语(埃及)
 ar-IQ    阿拉伯语(伊拉克)
 ar-JO    阿拉伯语(约旦)
 ar-KW    阿拉伯语(科威特)
 ar-LB    阿拉伯语(黎巴嫩)
 ar-LY    阿拉伯语(利比亚)
 ar-MA    阿拉伯语(摩洛哥)
 ar-OM    阿拉伯语(阿曼)
 ar-QA    阿拉伯语(卡塔尔)
 ar-SA    阿拉伯语(沙特阿拉伯)
 ar-SY    阿拉伯语(叙利亚)
 ar-TN    阿拉伯语(突尼斯)
 ar-YE    阿拉伯语(也门)
 az    阿塞拜疆语
 az-AZ    阿塞拜疆语(拉丁文)
 az-AZ    阿塞拜疆语(西里尔文)
 be    比利时语
 be-BY    比利时语
 bg    保加利亚语
 bg-BG    保加利亚语
 bs-BA    波斯尼亚语(拉丁文，波斯尼亚和黑塞哥维那)
 ca    加泰隆语
 ca-ES    加泰隆语
 cs    捷克语
 cs-CZ    捷克语
 cy    威尔士语
 cy-GB    威尔士语
 da    丹麦语
 da-DK    丹麦语
 de    德语
 de-AT    德语(奥地利)
 de-CH    德语(瑞士)
 de-DE    德语(德国)
 de-LI    德语(列支敦士登)
 de-LU    德语(卢森堡)
 dv    第维埃语
 dv-MV    第维埃语
 el    希腊语
 el-GR    希腊语
 en    英语
 en-AU    英语(澳大利亚)
 en-BZ    英语(伯利兹)
 en-CA    英语(加拿大)
 en-CB    英语(加勒比海)
 en-GB    英语(英国)
 en-IE    英语(爱尔兰)
 en-JM    英语(牙买加)
 en-NZ    英语(新西兰)
 en-PH    英语(菲律宾)
 en-TT    英语(特立尼达)
 en-US    英语(美国)
 en-ZA    英语(南非)
 en-ZW    英语(津巴布韦)
 eo    世界语
 es    西班牙语
 es-AR    西班牙语(阿根廷)
 es-BO    西班牙语(玻利维亚)
 es-CL    西班牙语(智利)
 es-CO    西班牙语(哥伦比亚)
 es-CR    西班牙语(哥斯达黎加)
 es-DO    西班牙语(多米尼加共和国)
 es-EC    西班牙语(厄瓜多尔)
 es-ES    西班牙语(传统)
 es-ES    西班牙语(国际)
 es-GT    西班牙语(危地马拉)
 es-HN    西班牙语(洪都拉斯)
 es-MX    西班牙语(墨西哥)
 es-NI    西班牙语(尼加拉瓜)
 es-PA    西班牙语(巴拿马)
 es-PE    西班牙语(秘鲁)
 es-PR    西班牙语(波多黎各(美))
 es-PY    西班牙语(巴拉圭)
 es-SV    西班牙语(萨尔瓦多)
 es-UY    西班牙语(乌拉圭)
 es-VE    西班牙语(委内瑞拉)
 et    爱沙尼亚语
 et-EE    爱沙尼亚语
 eu    巴士克语
 eu-ES    巴士克语
 fa    法斯语
 fa-IR    法斯语
 fi    芬兰语
 fi-FI    芬兰语
 fo    法罗语
 fo-FO    法罗语
 fr    法语
 fr-BE    法语(比利时)
 fr-CA    法语(加拿大)
 fr-CH    法语(瑞士)
 fr-FR    法语(法国)
 fr-LU    法语(卢森堡)
 fr-MC    法语(摩纳哥)
 gl    加里西亚语
 gl-ES    加里西亚语
 gu    古吉拉特语
 gu-IN    古吉拉特语
 he    希伯来语
 he-IL    希伯来语
 hi    印地语
 hi-IN    印地语
 hr    克罗地亚语
 hr-BA    克罗地亚语(波斯尼亚和黑塞哥维那)
 hr-HR    克罗地亚语
 hu    匈牙利语
 hu-HU    匈牙利语
 hy    亚美尼亚语
 hy-AM    亚美尼亚语
 id    印度尼西亚语
 id-ID    印度尼西亚语
 is    冰岛语
 is-IS    冰岛语
 it    意大利语
 it-CH    意大利语(瑞士)
 it-IT    意大利语(意大利)
 ja    日语
 ja-JP    日语
 ka    格鲁吉亚语
 ka-GE    格鲁吉亚语
 kk    哈萨克语
 kk-KZ    哈萨克语
 kn    卡纳拉语
 kn-IN    卡纳拉语
 ko    朝鲜语
 ko-KR    朝鲜语
 kok    孔卡尼语
 kok-IN    孔卡尼语
 ky    吉尔吉斯语
 ky-KG    吉尔吉斯语(西里尔文)
 lt    立陶宛语
 lt-LT    立陶宛语
 lv    拉脱维亚语
 lv-LV    拉脱维亚语
 mi    毛利语
 mi-NZ    毛利语
 mk    马其顿语
 mk-MK    马其顿语(FYROM)
 mn    蒙古语
 mn-MN    蒙古语(西里尔文)
 mr    马拉地语
 mr-IN    马拉地语
 ms    马来语
 ms-BN    马来语(文莱达鲁萨兰)
 ms-MY    马来语(马来西亚)
 mt    马耳他语
 mt-MT    马耳他语
 nb    挪威语(伯克梅尔)
 nb-NO    挪威语(伯克梅尔)(挪威)
 nl    荷兰语
 nl-BE    荷兰语(比利时)
 nl-NL    荷兰语(荷兰)
 nn-NO    挪威语(尼诺斯克)(挪威)
 ns    北梭托语
 ns-ZA    北梭托语
 pa    旁遮普语
 pa-IN    旁遮普语
 pl    波兰语
 pl-PL    波兰语
 pt    葡萄牙语
 pt-BR    葡萄牙语(巴西)
 pt-PT    葡萄牙语(葡萄牙)
 qu    克丘亚语
 qu-BO    克丘亚语(玻利维亚)
 qu-EC    克丘亚语(厄瓜多尔)
 qu-PE    克丘亚语(秘鲁)
 ro    罗马尼亚语
 ro-RO    罗马尼亚语
 ru    俄语
 ru-RU    俄语
 sa    梵文
 sa-IN    梵文
 se    北萨摩斯语
 se-FI    北萨摩斯语(芬兰)
 se-FI    斯科特萨摩斯语(芬兰)
 se-FI    伊那里萨摩斯语(芬兰)
 se-NO    北萨摩斯语(挪威)
 se-NO    律勒欧萨摩斯语(挪威)
 se-NO    南萨摩斯语(挪威)
 se-SE    北萨摩斯语(瑞典)
 se-SE    律勒欧萨摩斯语(瑞典)
 se-SE    南萨摩斯语(瑞典)
 sk    斯洛伐克语
 sk-SK    斯洛伐克语
 sl    斯洛文尼亚语
 sl-SI    斯洛文尼亚语
 sq    阿尔巴尼亚语
 sq-AL    阿尔巴尼亚语
 sr-BA    塞尔维亚语(拉丁文，波斯尼亚和黑塞哥维那)
 sr-BA    塞尔维亚语(西里尔文，波斯尼亚和黑塞哥维那)
 sr-SP    塞尔维亚(拉丁)
 sr-SP    塞尔维亚(西里尔文)
 sv    瑞典语
 sv-FI    瑞典语(芬兰)
 sv-SE    瑞典语
 sw    斯瓦希里语
 sw-KE    斯瓦希里语
 syr    叙利亚语
 syr-SY    叙利亚语
 ta    泰米尔语
 ta-IN    泰米尔语
 te    泰卢固语
 te-IN    泰卢固语
 th    泰语
 th-TH    泰语
 tl    塔加路语
 tl-PH    塔加路语(菲律宾)
 tn    茨瓦纳语
 tn-ZA    茨瓦纳语
 tr    土耳其语
 tr-TR    土耳其语
 ts    宗加语
 tt    鞑靼语
 tt-RU    鞑靼语
 uk    乌克兰语
 uk-UA    乌克兰语
 ur    乌都语
 ur-PK    乌都语
 uz    乌兹别克语
 uz-UZ    乌兹别克语(拉丁文)
 uz-UZ    乌兹别克语(西里尔文)
 vi    越南语
 vi-VN    越南语
 xh    班图语
 xh-ZA    班图语
 zh    中文
 zh-CN    中文(简体)
 zh-HK    中文(香港)
 zh-MO    中文(澳门)
 zh-SG    中文(新加坡)
 zh-TW    中文(繁体)
 zu    祖鲁语
 zu-ZA    祖鲁语
 ***/
