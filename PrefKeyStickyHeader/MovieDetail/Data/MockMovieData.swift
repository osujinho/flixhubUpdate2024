//
//  MovieData.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/8/23.
//

import Foundation

let mockTmdbMovieResult: [MovieCollection] = [oppenheimer, hunger, roomService, dune, pamasahe, leo, tahan, extraction, aquaman, lift, ron, ronin, focus, madagascar, anyone, aladdin, spies, heart, after, killers, badSister, titans, rileyMovie]

let oppenheimer: MovieCollection = .init(
    id: 872585,
    title: "Oppenheimer",
    poster: "/ptpr0kGAckfQkJeJIt8st5dglvd.jpg",
    releaseDate: "2023-07-19",
    genreIds: [18, 36],
    rating: 8.153
)
    
let extraction: MovieCollection = .init(
    id: 545609,
    title: "Extraction",
    poster: "/nygOUcBKPHFTbxsYRFZVePqgPK6.jpg",
    releaseDate: "2020-04-24",
    genreIds: [28, 53],
    rating: 7.343
)

let hunger: MovieCollection = .init(
    id: 695721,
    title: "The Hunger Games: The Ballad of Songbirds & Snakes",
    poster: "/mBaXZ95R2OxueZhvQbcEWy2DqyO.jpg",
    releaseDate: "2023-11-15",
    genreIds: [18, 878, 28],
    rating: 7.231
)

let aquaman: MovieCollection = .init(
    id: 572802,
    title: "Aquaman and the Lost Kingdom",
    poster: "/7lTnXOy0iNtBAdRP3TZvaKJ77F6.jpg",
    releaseDate: "2023-12-22",
    genreIds: [28, 12, 14],
    rating: 6.533
)

let pamasahe: MovieCollection = .init(
    id: 1041898,
    title: "Pamasahe",
    poster: "/r132GuHMQ5UhuMa3nwu6jbyJxmJ.jpg",
    releaseDate: "2022-12-09",
    genreIds: [18],
    rating: 6.528
)

let roomService: MovieCollection = .init(
    id: 1225592,
    title: "Room Service",
    poster: "/6n07uso5QdBrLBzWmmLAJYV2dLJ.jpg",
    releaseDate: "2024-01-16",
    genreIds: [18],
    rating: 4.2
)

let tahan: MovieCollection = .init(
    id: 998282,
    title: "Tahan",
    poster: "/1Sw6z9G2dDomgYx5J3clcwZ7TMi.jpg",
    releaseDate: "2022-07-22",
    genreIds: [18, 53],
    rating: 4.5
)

let lift: MovieCollection = .init(
    id: 955916,
    title: "Lift",
    poster: "/46sp1Z9b2PPTgCMyA87g9aTLUXi.jpg",
    releaseDate: "2024-01-10",
    genreIds: [28, 35, 80],
    rating: 6.584
)

let ron: MovieCollection = .init(
    id: 482321,
    title: "Ron's Gone Wrong",
    poster: "/plzgQAXIEHm4Y92ktxU6fedUc0x.jpg",
    releaseDate: "2021-10-22", 
    genreIds: [16, 878, 10751, 35],
    rating: 7.936
)

let ronin: MovieCollection = .init(
    id: 732459,
    title: "Blade of the 47 Ronin",
    poster: "/kjFDIlUCJkcpFxYKtE6OsGcAfQQ.jpg",
    releaseDate: "2022-10-25", 
    genreIds: [14],
    rating: 6.572
)

let dune: MovieCollection = .init(
    id: 438631,
    title: "Dune",
    poster: "/d5NXSklXo0qyIYkgV94XAgMIckC.jpg",
    releaseDate: "2021-09-15",
    genreIds: [878, 12],
    rating: 7.8
)

let aladdin: MovieCollection = .init(
    id: 420817,
    title: "Aladdin",
    poster: "/ykUEbfpkf8d0w49pHh0AD2KrT52.jpg",
    releaseDate: "2019-05-22",
    genreIds: [12, 14, 10751, 10749],
    rating: 7.107
)

let heart: MovieCollection = .init(
    id: 724209,
    title: "Heart of Stone",
    poster: "/vB8o2p4ETnrfiWEgVxHmHWP9yRl.jpg",
    releaseDate: "2023-08-09",
    genreIds: [28, 53],
    rating: 6.851
)

let after: MovieCollection = .init(
    id: 537915,
    title: "After",
    poster: "/u3B2YKUjWABcxXZ6Nm9h10hLUbh.jpg",
    releaseDate: "2019-04-11",
    genreIds: [18, 10749],
    rating: 7.134
)

let killers: MovieCollection = .init(
    id: 37821,
    title: "Killers",
    poster: "/9VB8vGV4Aznf6GUc9C7a1EzGHLz.jpg",
    releaseDate: "2010-06-04",
    genreIds: [28, 35, 53, 10749],
    rating: 5.956
)

let badSister: MovieCollection = .init(
    id: 375846,
    title: "Bad Sister",
    poster: "/jKrIlgfJPIWNeowaOZPBZuOPmq0.jpg",
    releaseDate: "2015-08-24", 
    genreIds: [53, 10770],
    rating: 6.666
)

let titans: MovieCollection = .init(
    id: 10637,
    title: "Remember the Titans",
    poster: "/825ohvC4wZ3gCuncCaqkWeQnK8h.jpg",
    releaseDate: "2000-09-29", 
    genreIds: [18],
    rating: 7.624
)

let rileyMovie: MovieCollection = .init(
    id: 355338,
    title: "Riley's First Date?",
    poster: "/cGLwfmLqg39822RFQMUDat0UJev.jpg",
    releaseDate: "2015-11-03", 
    genreIds: [16, 10751],
    rating: 7.141
)

let waterLilie: MovieCollection = .init(
    id: 10818,
    title: "Water Lilies",
    poster: "/oNrs9disgGDtOORToDt5dIqYFBi.jpg",
    releaseDate: "2007-05-17", 
    genreIds: [18, 10749],
    rating: 6.525
)

let madagascar: MovieCollection = .init(
    id: 953,
    title: "Madagascar",
    poster: "/zMpJY5CJKUufG9OTw0In4eAFqPX.jpg",
    releaseDate: "2005-05-25", 
    genreIds: [10751, 16, 12, 35],
    rating: 6.9
)

let spies: MovieCollection = .init(
    id: 431693,
    title: "Spies in Disguise",
    poster: "/30YacPAcxpNemhhwX0PVUl9pVA3.jpg",
    releaseDate: "2019-12-04",
    genreIds: [16, 28, 12, 35, 10751],
    rating: 7.61
)

let focus: MovieCollection = .init(
    id: 256591,
    title: "Focus",
    poster: "/lOzGWjceYTd0kd5HyX7Ch46O9kh.jpg",
    releaseDate: "2015-02-25",
    genreIds: [35, 80, 10749],
    rating: 6.877
)

let anyone: MovieCollection = .init(
    id: 1072790,
    title: "Anyone But You",
    poster: "/5qHoazZiaLe7oFBok7XlUhg96f2.jpg",
    releaseDate: "2023-12-21",
    genreIds: [35, 10749],
    rating: 7.004
)

let leo: MovieCollection = .init(
    id: 1075794,
    title: "Leo",
    poster: "/m3A3nvOddwkenc6Laxs4WS1UTo1.jpg",
    releaseDate: "2023-11-17",
    genreIds: [16, 35, 10751],
    rating: 7.499
)
