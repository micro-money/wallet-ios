//
//  StorageManager.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation
import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    
    private let realmQueue = DispatchQueue(label: "realm_queue")
    
    private init() {
        var config = Realm.Configuration()
        config.schemaVersion = 25
        config.migrationBlock = { migration, oldSchemaVersion in
            if (oldSchemaVersion < 25) {
                
            }
        }
        Realm.Configuration.defaultConfiguration = config
    }
    
    // MARK: - Common read/write methods
    
    private func getObject<T>(block: (Realm) -> T?) -> T? {
        var object: T? = nil
        do {
            let realm = try Realm()
            object = block(realm)
        } catch {
            print("Read error: \(error)")
        }
        return object
    }
    
    func write(block: ((Realm) throws -> ())) {
        realmQueue.sync {
            do {
                let realm = try Realm()
                try realm.write {
                    do {
                        try block(realm)
                    } catch let error {
                        print("Write error: \(error)")
                    }
                }
            } catch {
                print("Write error: \(error)")
            }
        }
    }
    
    // MARK: - Read methods
    
    func getUser(id: Int) -> UserModel? {
        return getObject {
            $0.object(ofType: UserModel.self, forPrimaryKey: id)
        }
    }
    
    func getUsers() -> [UserModel]? {
        return getObject {
            $0.objects(UserModel.self)
            }?.toArray()
    }

    func getWallet(id: Int) -> WalletModel? {
        return getObject {
            $0.object(ofType: WalletModel.self, forPrimaryKey: id)
        }
    }

    func getWallet() -> WalletModel? {
        return getObject {
            $0.objects(WalletModel.self)
        }!.first
    }

    func getWallets() -> [WalletModel]? {
        return getObject {
            $0.objects(WalletModel.self)
        }!.toArray()
    }

    func getAssets() -> [AssetModel]? {
        return getObject {
            $0.objects(AssetModel.self)
        }!.toArray()
    }

    func getAsset(id: Int) -> AssetModel? {
        return getObject {
            $0.object(ofType: AssetModel.self, forPrimaryKey: id)
        }
    }

    func getAssetDetails() -> [AssetDetailModel]? {
        return getObject {
            $0.objects(AssetDetailModel.self)
        }!.toArray()
    }

    func getAssetDetail(id: Int) -> AssetDetailModel? {
        return getObject {
            $0.object(ofType: AssetDetailModel.self, forPrimaryKey: id)
        }
    }

    func getAssets(currency: String) -> [AssetModel]? {
        return getObject {
            $0.objects(AssetModel.self)
        }!.filter("symbol == %@", currency).toArray()
    }

    func getAsset(currency: String) -> AssetModel? {
        return getObject {
            $0.objects(AssetModel.self)
        }!.filter("symbol == %@", currency).toArray().first
    }

    func getAssets(type: AssetType) -> [AssetModel]? {
        //TODO: temporarily off BTC
        if type == .crypto {
            return getObject {
                $0.objects(AssetModel.self)
            }!.filter("typeString == %@", type.rawValue).filter("symbol == %@", "ETH").toArray()
        }
        return getObject {
            $0.objects(AssetModel.self)
        }!.filter("typeString == %@", type.rawValue).toArray()
    }

    func getTransaction(id: Int) -> TransactionModel? {
        return getObject {
            $0.object(ofType: TransactionModel.self, forPrimaryKey: id)
        }
    }

    func getTransactions() -> [TransactionModel]? {
        return getObject {
            $0.objects(TransactionModel.self)
        }!.toArray()
    }

    func getTransactionDetails() -> [TransactionDetailModel]? {
        return getObject {
            $0.objects(TransactionDetailModel.self)
        }!.toArray()
    }

    func getConverter(id: String) -> ConverterModel? {
        return getObject {
            $0.object(ofType: ConverterModel.self, forPrimaryKey: id)
        }
    }

    func getTransactionDetail(id: Int) -> TransactionDetailModel? {
        return getObject {
            $0.object(ofType: TransactionDetailModel.self, forPrimaryKey: id)
        }
    }

    func getCurrencyRates() -> [CurrencyRateModel]? {
        return getObject {
            $0.objects(CurrencyRateModel.self)
        }!.toArray()
    }

    func getCurrencyRateLast7Days(currency: String) -> [CurrencyRateModel]? {
        let todayStart = Date()
        let components = DateComponents(day: -7)
        let todayEnd = Calendar.current.date(byAdding: components, to: todayStart)!

        return getObject {
            $0.objects(CurrencyRateModel.self)
        }!.filter("currency == %@ AND createdAt BETWEEN %@", currency, [todayEnd, todayStart]).toArray()
    }

    func getContacts() -> [ContactModel]? {
        return getObject {
            $0.objects(ContactModel.self)
        }!.filter("name != %@", "Me").toArray()
    }

    func getContact(id: Int) -> ContactModel? {
        return getObject {
            $0.object(ofType: ContactModel.self, forPrimaryKey: id)
        }
    }

    func getContact(name: String) -> ContactModel? {
        return getObject {
            $0.objects(ContactModel.self)
        }!.filter("name == %@", name).toArray().first
    }

    func getContactDetail(id: Int) -> ContactDetailModel? {
        return getObject {
            $0.object(ofType: ContactDetailModel.self, forPrimaryKey: id)
        }
    }

    func getContactPhone(id: Int) -> ContactPhoneModel? {
        return getObject {
            $0.object(ofType: ContactPhoneModel.self, forPrimaryKey: id)
        }
    }
    func getContactEmail(id: Int) -> ContactEmailModel? {
        return getObject {
            $0.object(ofType: ContactEmailModel.self, forPrimaryKey: id)
        }
    }
    func getContactAddress(id: Int) -> ContactAddressModel? {
        return getObject {
            $0.object(ofType: ContactAddressModel.self, forPrimaryKey: id)
        }
    }

    /*
    func getContactAddress(contactId: Int, currency: String) -> [ContactAddressModel]? {
        return getObject {
            $0.objects(ContactDetailModel.self)
        }!.filter("id == %d", contactId).filter("address.@currency == %@", currency).toArray()
    }
    */

    func getSpeedPrice(id: String) -> SpeedPriceModel? {
        return getObject {
            $0.object(ofType: SpeedPriceModel.self, forPrimaryKey: id)
        }
    }
    
    // MARK: - Write methods
    
    func save(object: Object, update: Bool) {
        write { realm in
            realm.add(object, update: update)
        }
    }
    
    func save(objects: [Object], update: Bool) {
        write { realm in
            realm.add(objects, update: update)
        }
    }
    
    // MARK: - Set methods

    func setContactPhone(contactPhoneId: Int, value: String) {
        if let contactPhone = getContactPhone(id: contactPhoneId) {
            write { realm in
                contactPhone.phone = value
            }
        }
    }

    func setContactEmail(contactEmailId: Int, value: String) {
        if let contactEmail = getContactEmail(id: contactEmailId) {
            write { realm in
                contactEmail.email = value
            }
        }
    }

    func setContactDescription(contactId: Int, value: String) {
        if let contactContactDetail = getContactDetail(id: contactId) {
            write { realm in
                contactContactDetail.descr = value
            }
        }
    }
    
    // MARK: - Delete methods
    
    func clean() {
        write { realm in
            realm.deleteAll()
        }
    }
    
    func delete(object: Object) {
        write { realm in
            realm.delete(object)
        }
    }
    
    func delete(objects: [Object]) {
        write { realm in
            realm.delete(objects)
        }
    }

    func deleteWallet() {
        deleteAllAssets()

        let objects = getWallets()
        if objects != nil {
            delete(objects: objects!)
        }
    }
    
    func deleteAllUsers() {
        let objects = getUsers()
        if objects != nil {
            delete(objects: objects!)
        }
    }

    func deleteAllContacts() {
        let objects = getContacts()
        if objects != nil {
            delete(objects: objects!)
        }
    }

    func deleteAllAssets() {
        let objects = getAssets()
        if objects != nil {
            delete(objects: objects!)
        }
    }

    func deleteAsset(assetId: Int) {
        let asset = getAsset(id: assetId)
        if asset != nil {
            delete(object: asset!)
        }
    }

    func deleteContact(contactId: Int) {
        let contact = getContact(id: contactId)
        if contact != nil {
            delete(object: contact!)
        }

        let contactDetail = getContactDetail(id: contactId)
        if contactDetail != nil {
            delete(object: contactDetail!)
        }
    }

    func deleteContactAddress(addressId: Int) {
        let address = getContactAddress(id: addressId)
        if address != nil {
            delete(object: address!)
        }
    }
    
}
