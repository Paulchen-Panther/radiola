//
//  TestArtworkFetcher.swift
//  RadiolaTests
//

@testable import Radiola
import XCTest

extension RadiolaTests {
    /* ****************************************
     *
     * ****************************************/
    func testArtworkFetcherURL() throws {
        let fetcher = ArtworkFetcher.shared

        // Valid "Artist - Title" returns a URL containing both terms
        let url = fetcher.iTunesURL(for: "The Beatles - Let It Be")
        XCTAssertNotNil(url)
        let urlString = url!.absoluteString
        XCTAssertTrue(urlString.contains("itunes.apple.com/search"))
        XCTAssertTrue(urlString.contains("The%20Beatles"))
        XCTAssertTrue(urlString.contains("Let%20It%20Be") || urlString.contains("Let+It+Be"))

        // Title with extra " - " is handled: everything after the first separator is the title
        let url2 = fetcher.iTunesURL(for: "Artist - Title - Extra")
        XCTAssertNotNil(url2)

        // No separator → nil
        XCTAssertNil(fetcher.iTunesURL(for: "No Separator Here"))

        // Empty string → nil
        XCTAssertNil(fetcher.iTunesURL(for: ""))

        // Only separator, no artist → nil
        XCTAssertNil(fetcher.iTunesURL(for: " - Title"))

        // Only separator, no title → nil
        XCTAssertNil(fetcher.iTunesURL(for: "Artist - "))
    }
}
