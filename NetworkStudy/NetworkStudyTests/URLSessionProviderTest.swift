//
//  URLSessionProviderTest.swift
//  NetworkStudyTests
//
//  Created by jiinheo on 2023/02/25.
//

import XCTest
@testable import NetworkStudy

class URLSessionProviderTest: XCTestCase {
    
    let mockSession = MockURLSession()
    var sut: ProviderImpl!
    

    override func setUpWithError() throws {
        sut = .init(session: mockSession)
    }
    
    func test_getUser_success() {
        let response = try? JSONDecoder().decode(User.self, from: MockData().data)
        
        // MockURLSession을 통해 테스트
        sut.getUser(id: 1) { result in
            switch result {
            case .success(let data):
                guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                    XCTFail("Decode Error")
                    return
                }
                XCTAssertEqual(user.id, response?.id)
                XCTAssertEqual(user.name, response?.name)
            case .failure(_):
                XCTFail("getUser failure")
            }
        }
    }
    
    func test_getUser_failuer() {
        
        // Mocksession이 강제로 실패하도록 설정
        sut = ProviderImpl(session: MockURLSession(isRequestSuccess: false))
        
        // MockSession의 실패 응답의 httpStatus가 402로 설정되었으므로 반환되는 에러는 statusCodeError
        sut.getUser(id: 1) { result in
            switch result {
            case .success(_):
                XCTFail("result is success")
            case .failure(let error):
                XCTAssertEqual(error, CustomError.statusCodeError)
            }
        }
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
