//
//  API.swift
//  Picture Gallery
//
//  Created by Iftiquar Ahmed Ove on 22/6/22.
//

import Foundation
import Alamofire

class PhotoWebServices {
    static let shared = PhotoWebServices()
    
    enum endpoints{
        static let base = "https://api.unsplash.com/"
        case getPhotos
        var string_value: String{
            switch self {
            case .getPhotos:
                return endpoints.base + "photos"
            }
        }
        
        var url: URL{
            return URL(string: string_value) ?? URL(string: "")!
        }
    }
    
    // MARK: - Functions
    
    // *************************** Get Photos by page ************************
    // -----------------------------------------------------------------------
    
    /// Get Photos by page
    /// - Parameters:
    ///   - page: the page number of what images will be displayed
    ///   - success: completion with expected params
    func getPhotosByPage(page: Int, success: @escaping(_ status: Int, _ photoElement: Photo?, _ error: String?)-> Void){
        let headers: HTTPHeaders = [API_HEADER_KEY : API_HEADER_VALUE]
        let params: Parameters = [ "page": page, "per_page": 10]
        
        if !Utlity.isConnectedToNetwork(){
            success(400,nil,"Please Check your network connection")
        }
        
        AF.request(endpoints.getPhotos.url, method: .get, parameters: params, headers: headers).responseDecodable(of: Photo.self) { (response) in
            switch response.result{
            case .success(let result):
                success(200,result,nil)
            case .failure(let error):
                success(400,nil,error.localizedDescription)
                print("⚠️ Error Fetching Photos from Server: ",error.localizedDescription)
            }
        }
    }
}

