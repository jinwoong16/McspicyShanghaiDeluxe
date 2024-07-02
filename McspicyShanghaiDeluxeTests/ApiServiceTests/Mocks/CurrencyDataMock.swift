//
//  CurrencyDataMock.swift
//  McspicyShanghaiDeluxeTests
//
//  Created by jinwoong Kim on 7/2/24.
//

import Foundation

let jsonData = """
{"amount":1.0,"base":"KRW","date":"2024-07-01","rates":{"AUD":0.00108,"BRL":0.00404,"CAD":0.00099,"CHF":0.00065,"CNY":0.00526,"CZK":0.01686,"DKK":0.00502,"EUR":0.00067,"GBP":0.00057,"HKD":0.00565,"HUF":0.26541,"IDR":11.8277,"ILS":0.00271,"INR":0.06036,"JPY":0.11657,"MXN":0.01328,"MYR":0.00341,"NOK":0.0077,"NZD":0.00119,"PHP":0.04241,"PLN":0.0029,"RON":0.00335,"SEK":0.00765,"SGD":0.00098,"THB":0.02655,"TRY":0.02364,"USD":0.00072,"ZAR":0.01313}}
"""
    .data(using: .utf8)!
