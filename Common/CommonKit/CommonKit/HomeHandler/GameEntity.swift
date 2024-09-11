//
//  HomeModuleEntity.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

//  HomeModuleEntity.swift
//  HomeModule

import Foundation

public struct Game: Codable {
    public struct ESRBRating: Codable {
        public let id: Int
        public let slug: String
        public let name: String
        
        public init(id: Int, slug: String, name: String) {
            self.id = id
            self.slug = slug
            self.name = name
        }
    }
    
    public struct PlatformInfo: Codable {
        public struct Platform: Codable {
            public let id: Int
            public let slug: String
            public let name: String
            
            public init(id: Int, slug: String, name: String) {
                self.id = id
                self.slug = slug
                self.name = name
            }
        }
        public let platform: Platform
        public let released_at: String?
        public let requirements: Requirements?
        
        public init(platform: Platform, released_at: String?, requirements: Requirements?) {
            self.platform = platform
            self.released_at = released_at
            self.requirements = requirements
        }
    }
    
    public struct Requirements: Codable {
        public let minimum: String?
        public let recommended: String?
        
        public init(minimum: String?, recommended: String?) {
            self.minimum = minimum
            self.recommended = recommended
        }
    }
    
    public struct Rating: Codable {
        public let id: Int
        public let title: String
        public let count: Int
        public let percent: Double
        
        public init(id: Int, title: String, count: Int, percent: Double) {
            self.id = id
            self.title = title
            self.count = count
            self.percent = percent
        }
    }
    
    public struct AddedByStatus: Codable {
        public let yet: Int?
        public let owned: Int?
        public let beaten: Int?
        public let toplay: Int?
        public let dropped: Int?
        public let playing: Int?
        
        public init(yet: Int?, owned: Int?, beaten: Int?, toplay: Int?, dropped: Int?, playing: Int?) {
            self.yet = yet
            self.owned = owned
            self.beaten = beaten
            self.toplay = toplay
            self.dropped = dropped
            self.playing = playing
        }
    }
    
    public let id: Int?
    public let slug: String
    public let name: String?
    public let released: String?
    public let tba: Bool
    public let background_image: String?
    public let rating: Double
    public let rating_top: Int?
    public let ratings: [Rating]?
    public let ratings_count: Int?
    public let reviews_text_count: Int?
    public let added: Int?
    public let added_by_status: AddedByStatus?
    public let metacritic: Int?
    public let playtime: Int?
    public let suggestions_count: Int?
    public let updated: String?
    public let esrb_rating: ESRBRating?
    public let platforms: [PlatformInfo]?
    
    public init(id: Int?, slug: String, name: String, released: String?, tba: Bool, background_image: String?, rating: Double, rating_top: Int?, ratings: [Rating]?, ratings_count: Int?, reviews_text_count: Int?, added: Int?, added_by_status: AddedByStatus?, metacritic: Int?, playtime: Int?, suggestions_count: Int?, updated: String?, esrb_rating: ESRBRating?, platforms: [PlatformInfo]?) {
        self.id = id
        self.slug = slug
        self.name = name
        self.released = released
        self.tba = tba
        self.background_image = background_image
        self.rating = rating
        self.rating_top = rating_top
        self.ratings = ratings
        self.ratings_count = ratings_count
        self.reviews_text_count = reviews_text_count
        self.added = added
        self.added_by_status = added_by_status
        self.metacritic = metacritic
        self.playtime = playtime
        self.suggestions_count = suggestions_count
        self.updated = updated
        self.esrb_rating = esrb_rating
        self.platforms = platforms
    }
}

public typealias GameListDetailsResult = Result<GameListDetailsResponse, Error>

public struct GameListDetailsResponse: Decodable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [Game]
    
    public init(count: Int, next: String?, previous: String?, results: [Game]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}
//
//
//{"id":3498,
//    "slug":"grand-theft-auto-v",
//    "name":"Grand Theft Auto V",
//    "released":"2013-09-17",
//    "tba":false,
//    "background_image":"https://media.rawg.io/media/games/20a/20aa03a10cda45239fe22d035c0ebe64.jpg",
//    "rating":4.47,
//    "rating_top":5,
//    "ratings":[{"id":5,"title":"exceptional","count":4123,"percent":59.14},{"id":4,"title":"recommended","count":2279,"percent":32.69},{"id":3,"title":"meh","count":441,"percent":6.33},{"id":1,"title":"skip","count":129,"percent":1.85}],
//    "ratings_count":6866,
//    "reviews_text_count":62,
//    "added":21147,
//    "added_by_status":
//    ,"metacritic":92,
//    "playtime":74,
//    "suggestions_count":434,
//    "updated":"2024-09-10T22:49:56",
//    "user_game":null,
//    "reviews_count":6972,
//    "saturated_color":"0f0f0f",
//    "dominant_color":"0f0f0f",
//    "platforms":[{"platform":{"id":4,"name":"PC","slug":"pc","image":null,"year_end":null,"year_start":null,"games_count":535509,"image_background":"https://media.rawg.io/media/games/bc0/bc06a29ceac58652b684deefe7d56099.jpg"},"released_at":"2013-09-17","requirements_en":{"minimum":"Minimum:OS: Windows 10 64 Bit, Windows 8.1 64 Bit, Windows 8 64 Bit, Windows 7 64 Bit Service Pack 1, Windows Vista 64 Bit Service Pack 2* (*NVIDIA video card recommended if running Vista OS)Processor: Intel Core 2 Quad CPU Q6600 @ 2.40GHz (4 CPUs) / AMD Phenom 9850 Quad-Core Processor (4 CPUs) @ 2.5GHzMemory: 4 GB RAMGraphics: NVIDIA 9800 GT 1GB / AMD HD 4870 1GB (DX 10, 10.1, 11)Storage: 72 GB available spaceSound Card: 100% DirectX 10 compatibleAdditional Notes: Over time downloadable content and programming changes will change the system requirements for this game.  Please refer to your hardware manufacturer and www.rockstargames.com/support for current compatibility information. Some system components such as mobile chipsets, integrated, and AGP graphics cards may be incompatible. Unlisted specifications may not be supported by publisher.     Other requirements:  Installation and online play requires log-in to Rockstar Games Social Club (13+) network; internet connection required for activation, online play, and periodic entitlement verification; software installations required including Rockstar Games Social Club platform, DirectX , Chromium, and Microsoft Visual C++ 2008 sp1 Redistributable Package, and authentication software that recognizes certain hardware attributes for entitlement, digital rights management, system, and other support purposes.     SINGLE USE SERIAL CODE REGISTRATION VIA INTERNET REQUIRED; REGISTRATION IS LIMITED TO ONE ROCKSTAR GAMES SOCIAL CLUB ACCOUNT (13+) PER SERIAL CODE; ONLY ONE PC LOG-IN ALLOWED PER SOCIAL CLUB ACCOUNT AT ANY TIME; SERIAL CODE(S) ARE NON-TRANSFERABLE ONCE USED; SOCIAL CLUB ACCOUNTS ARE NON-TRANSFERABLE.  Partner Requirements:  Please check the terms of service of this site before purchasing this software.","recommended":"Recommended:OS: Windows 10 64 Bit, Windows 8.1 64 Bit, Windows 8 64 Bit, Windows 7 64 Bit Service Pack 1Processor: Intel Core i5 3470 @ 3.2GHz (4 CPUs) / AMD X8 FX-8350 @ 4GHz (8 CPUs)Memory: 8 GB RAMGraphics: NVIDIA GTX 660 2GB / AMD HD 7870 2GBStorage: 72 GB available spaceSound Card: 100% DirectX 10 compatibleAdditional Notes:"},"requirements_ru":null},{"platform":{"id":187,"name":"PlayStation 5","slug":"playstation5","image":null,"year_end":null,"year_start":2020,"games_count":1113,"image_background":"https://media.rawg.io/media/games/f24/f2493ea338fe7bd3c7d73750a85a0959.jpeg"},"released_at":"2013-09-17","requirements_en":null,"requirements_ru":null},{"platform":{"id":186,"name":"Xbox Series S/X","slug":"xbox-series-x","image":null,"year_end":null,"year_start":2020,"games_count":978,"image_background":"https://media.rawg.io/media/games/34b/34b1f1850a1c06fd971bc6ab3ac0ce0e.jpg"},"released_at":"2013-09-17","requirements_en":null,"requirements_ru":null},{"platform":{"id":18,"name":"PlayStation 4","slug":"playstation4","image":null,"year_end":null,"year_start":null,"games_count":6829,"image_background":"https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bcdbc.jpg"},"released_at":"2013-09-17","requirements_en":null,"requirements_ru":null},{"platform":{"id":16,"name":"PlayStation 3","slug":"playstation3","image":null,"year_end":null,"year_start":null,"games_count":3166,"image_background":"https://media.rawg.io/media/games/021/021c4e21a1824d2526f925eff6324653.jpg"},"released_at":"2013-09-17","requirements_en":null,"requirements_ru":null},{"platform":{"id":14,"name":"Xbox 360","slug":"xbox360","image":null,"year_end":null,"year_start":null,"games_count":2806,"image_background":"https://media.rawg.io/media/games/157/15742f2f67eacff546738e1ab5c19d20.jpg"},"released_at":"2013-09-17","requirements_en":null,"requirements_ru":null},{"platform":{"id":1,"name":"Xbox One","slug":"xbox-one","image":null,"year_end":null,"year_start":null,"games_count":5641,"image_background":"https://media.rawg.io/media/games/157/15742f2f67eacff546738e1ab5c19d20.jpg"},"released_at":"2013-09-17","requirements_en":null,"requirements_ru":null}],
//    "parent_platforms":[{"platform":{"id":1,"name":"PC","slug":"pc"}},{"platform":{"id":2,"name":"PlayStation","slug":"playstation"}},{"platform":{"id":3,"name":"Xbox","slug":"xbox"}}],
//    "genres":[{"id":4,"name":"Action","slug":"action","games_count":182068,"image_background":"https://media.rawg.io/media/games/b7d/b7d3f1715fa8381a4e780173a197a615.jpg"}],
//    "stores":[{"id":290375,"store":{"id":3,"name":"PlayStation Store","slug":"playstation-store","domain":"store.playstation.com","games_count":7963,"image_background":"https://media.rawg.io/media/games/960/960b601d9541cec776c5fa42a00bf6c4.jpg"}},{"id":438095,"store":{"id":11,"name":"Epic Games","slug":"epic-games","domain":"epicgames.com","games_count":1345,"image_background":"https://media.rawg.io/media/games/942/9424d6bb763dc38d9378b488603c87fa.jpg"}},{"id":290376,"store":{"id":1,"name":"Steam","slug":"steam","domain":"store.steampowered.com","games_count":98563,"image_background":"https://media.rawg.io/media/games/587/587588c64afbff80e6f444eb2e46f9da.jpg"}},{"id":290377,"store":{"id":7,"name":"Xbox 360 Store","slug":"xbox360","domain":"marketplace.xbox.com","games_count":1916,"image_background":"https://media.rawg.io/media/games/960/960b601d9541cec776c5fa42a00bf6c4.jpg"}},{"id":290378,"store":{"id":2,"name":"Xbox Store","slug":"xbox-store","domain":"microsoft.com","games_count":4868,"image_background":"https://media.rawg.io/media/games/157/15742f2f67eacff546738e1ab5c19d20.jpg"}}],
//    "clip":null,
//    "tags":[{"id":31,"name":"Singleplayer","slug":"singleplayer","language":"eng","games_count":227300,"image_background":"https://media.rawg.io/media/games/490/49016e06ae2103881ff6373248843069.jpg"},{"id":40847,"name":"Steam Achievements","slug":"steam-achievements","language":"eng","games_count":39573,"image_background":"https://media.rawg.io/media/games/7cf/7cfc9220b401b7a300e409e539c9afd5.jpg"},{"id":7,"name":"Multiplayer","slug":"multiplayer","language":"eng","games_count":38617,"image_background":"https://media.rawg.io/media/games/960/960b601d9541cec776c5fa42a00bf6c4.jpg"},{"id":40836,"name":"Full controller support","slug":"full-controller-support","language":"eng","games_count":18795,"image_background":"https://media.rawg.io/media/games/8e4/8e4de3f54ac659e08a7ba6a2b731682a.jpg"},{"id":13,"name":"Atmospheric","slug":"atmospheric","language":"eng","games_count":34121,"image_background":"https://media.rawg.io/media/games/2ba/2bac0e87cf45e5b508f227d281c9252a.jpg"},{"id":42,"name":"Great Soundtrack","slug":"great-soundtrack","language":"eng","games_count":3406,"image_background":"https://media.rawg.io/media/games/8a0/8a02f84a5916ede2f923b88d5f8217ba.jpg"},{"id":24,"name":"RPG","slug":"rpg","language":"eng","games_count":21772,"image_background":"https://media.rawg.io/media/games/713/713269608dc8f2f40f5a670a14b2de94.jpg"},{"id":18,"name":"Co-op","slug":"co-op","language":"eng","games_count":11956,"image_background":"https://media.rawg.io/media/games/c6b/c6bfece1daf8d06bc0a60632ac78e5bf.jpg"},{"id":36,"name":"Open World","slug":"open-world","language":"eng","games_count":7733,"image_background":"https://media.rawg.io/media/games/16b/16b1b7b36e2042d1128d5a3e852b3b2f.jpg"},{"id":411,"name":"cooperative","slug":"cooperative","language":"eng","games_count":5181,"image_background":"https://media.rawg.io/media/games/0bd/0bd5646a3d8ee0ac3314bced91ea306d.jpg"},{"id":8,"name":"First-Person","slug":"first-person","language":"eng","games_count":32415,"image_background":"https://media.rawg.io/media/games/00d/00d374f12a3ab5f96c500a2cfa901e15.jpg"},{"id":149,"name":"Third Person","slug":"third-person","language":"eng","games_count":11948,"image_background":"https://media.rawg.io/media/games/da1/da1b267764d77221f07a4386b6548e5a.jpg"},{"id":4,"name":"Funny","slug":"funny","language":"eng","games_count":25381,"image_background":"https://media.rawg.io/media/games/e3d/e3ddc524c6292a435d01d97cc5f42ea7.jpg"},{"id":37,"name":"Sandbox","slug":"sandbox","language":"eng","games_count":7134,"image_background":"https://media.rawg.io/media/games/310/3106b0e012271c5ffb16497b070be739.jpg"},{"id":123,"name":"Comedy","slug":"comedy","language":"eng","games_count":12776,"image_background":"https://media.rawg.io/media/games/49c/49c3dfa4ce2f6f140cc4825868e858cb.jpg"},{"id":150,"name":"Third-Person Shooter","slug":"third-person-shooter","language":"eng","games_count":3524,"image_background":"https://media.rawg.io/media/games/16b/16b1b7b36e2042d1128d5a3e852b3b2f.jpg"},{"id":62,"name":"Moddable","slug":"moddable","language":"eng","games_count":952,"image_background":"https://media.rawg.io/media/games/62c/62c7c8b28a27b83680b22fb9d33fc619.jpg"},{"id":144,"name":"Crime","slug":"crime","language":"eng","games_count":2894,"image_background":"https://media.rawg.io/media/games/20a/20aa03a10cda45239fe22d035c0ebe64.jpg"},{"id":62349,"name":"vr mod","slug":"vr-mod","language":"eng","games_count":17,"image_background":"https://media.rawg.io/media/screenshots/1bb/1bb3f78f0fe43b5d5ca2f3da5b638840.jpg"}],
//    "esrb_rating":{"id":4,"name":"Mature","slug":"mature"},
//    "short_screenshots":[{"id":-1,"image":"https://media.rawg.io/media/games/20a/20aa03a10cda45239fe22d035c0ebe64.jpg"},{"id":1827221,"image":"https://media.rawg.io/media/screenshots/a7c/a7c43871a54bed6573a6a429451564ef.jpg"},{"id":1827222,"image":"https://media.rawg.io/media/screenshots/cf4/cf4367daf6a1e33684bf19adb02d16d6.jpg"},{"id":1827223,"image":"https://media.rawg.io/media/screenshots/f95/f9518b1d99210c0cae21fc09e95b4e31.jpg"},{"id":1827225,"image":"https://media.rawg.io/media/screenshots/a5c/a5c95ea539c87d5f538763e16e18fb99.jpg"},{"id":1827226,"image":"https://media.rawg.io/media/screenshots/a7e/a7e990bc574f4d34e03b5926361d1ee7.jpg"},{"id":1827227,"image":"https://media.rawg.io/media/screenshots/592/592e2501d8734b802b2a34fee2df59fa.jpg"}]}
