/* 
    This quest features an implementation of a price oracle module. The price oracle module 
    utilizes the 'push model' of price oracles where the oracle admin routinely pushes price 
    updates to the contract. 

    Price oracle: 
        A price oracle is an smart contract system that is responsible for moving price data from 
        the real world to the blockchain. The blockchain inherently does not have access to any 
        information that is off-chain. Oracles are used to bridge the gap between the blockchain 
        and the real world by providing real world data to the blockchain to be used in other 
        smart contracts. 

        This module implements a price oracle that is responsible for routinely updating the price
        of coin pairs that are used in the Aptos ecosystem. This oracle uses the 'push model' of
        price oracles where the oracle admin routinely pushes new price updates to the contract and 
        allows anyone to query the latest price of a coin pair at any time. 

    Price data: 
        All prices are stored in the PriceBoard resource which is a table of all available coin 
        pairs and their price data. The price data is stored in the PriceFeed struct which contains
        the latest attestation timestamp, the coin pair id, and the Price struct. The latest 
        attestation timestamp is the timestamp of when the price was last updated, which is used to 
        determine if a price is stale or not. The coin pair id is the string identifier of the coin
        pair. The Price struct contains the price of the coin pair and the confidence interval of
        the price. The price is the price of the coin pair scaled with 8 decimal places. The 
        confidence interval is the interval of which the price is accurate within. For example, if
        the price is 1000 and the confidence interval is 10, then the price is accurate within
        the 990 - 1010 range.

    Updating the prices: 
        The prices are to be routinely updated by the admin of the module. The admin is the 
        account that published this module. The admin can update the price of a coin pair by 
        calling the update_price_feed function. The update_price_feed function can only be called by 
        the admin. 

        The admin must provide the coin pair id, the price, and the confidence interval.

    Retrieving latest price: 
        The price of a coin pair can be retrieved three ways: 
        
            1. get_price: This method will return the latest price and confidence level of the 
                specified coin pair as long as the price is attested within the default maximum 
                attestation duration. The default maximum attestation duration is 3 hours. If the 
                price is not attested within the default maximum attestation duration, then the
                price is considered stale and the function will abort.

            2. get_price_no_older_than: This method will return the latest price and confidence
                level of the specified coin pair as long as the price is attested no later than
                the provided maximum age. If the price is not attested within the provided maximum
                age, then the price is considered stale and the function will abort.

            3. get_price_unsafe: This method will return the latest price, confidence level, and 
                attestation timestamp of the specified coin pair regardless of when it was 
                attested. This method is unsafe because it does not check if the price is stale
                or not. 

    Key Concepts: 
        - Price oracles & the 'push model' price oracle method
*/
module overmind::price_oracle {
    //==============================================================================================
    // Dependencies
    //==============================================================================================
    use std::signer;
    use std::string::String;
    use aptos_framework::event;
    use std::table::{Self, Table};
    use aptos_framework::timestamp;
    use aptos_framework::account::{Self, SignerCapability};

    #[test_only]
    use aptos_framework::string;

    //==============================================================================================
    // Constants - DO NOT MODIFY
    //==============================================================================================
    
    // seed for the module's resource account
    const SEED: vector<u8> = b"price oracle";
    
    //==============================================================================================
    // Error codes - DO NOT MODIFY
    //==============================================================================================
    const ErrorCodeForAllAborts: u64 = 1238177394;

    //==============================================================================================
    // Module Structs - DO NOT MODIFY
    //==============================================================================================

    /* 
        Holds price information for a specific coin pair
    */
    struct Price has copy, store, drop {
        // the price of the pair - with 8 decimal places
		price: u128, 
        // the confidence interval for the price - with 8 decimal places
        // the price is accurate within +/- confidence value
		confidence: u128
    }

    /* 
        Holds price feed information for a specific price
    */
    struct PriceFeed has copy, store, drop {
        // the timestamp of when the price was attested (submitted by the admin)
        latest_attestation_timestamp_seconds: u64,
        // the id of the coin pair - e.g. "APT/USDT"
        pair: String, 
        // the latest, attested price of the pair
        price: Price
    }

    /* 
        table of all price feeds. To be owned by the module's resource account
    */
    struct PriceBoard has key {
        // the table mapping all coin pair ids to their price feed
        // e.g. "APT/USDT" -> PriceFeed { ... }
        prices: Table<String, PriceFeed>
    }

    /* 
        Holds information to be used in the module. To be owned by the module's resource account
    */
    struct State has key {
        // the signer cap of the module's resource account
        signer_cap: SignerCapability, 
        // events
        price_feed_updated_event: event::EventHandle<PriceFeedUpdatedEvent>
    }
    
    //==============================================================================================
    // Event structs - DO NOT MODIFY
    //==============================================================================================

    /* 
        Event to be emitted when a price feed is updated
    */
    struct PriceFeedUpdatedEvent has store, drop {
        // the id of the coin pair - e.g. "APT/USDT"
        pair: String,
        // the latest, attested price of the pair
        price: Price, 
        // the timestamp of when the price was attested (submitted by the admin)
        update_timestamp_seconds: u64
    }

    //==============================================================================================
    // Functions
    //==============================================================================================

    /* 
        Initializes the module by creating the resource account, and setting up the State and 
            PriceBoard resources
        @param admin - signer representing the oracle admin
    */
    fun init_module(admin: &signer) { 
        // TODO: Create the resource account with admin account and provided SEED constant

        // TODO: Create the module's State resource and move it to the resource account

        // TODO: Create the module's PriceBoard resource and move it to the resource account
    }

    /* 
        Adds or updates the price of a specified pair. This function can only be called by the 
        oracle admin. Abort if the caller is not the admin.
        @param admin - signer representing the oracle admin
        @param pair - id/coin pair identifying the coin pair price being updated
        @param price - the new price scaled with 8 decimal places
        @param confidence - the interval of confidence for the price scaled with 8 decimal places
    */
    public entry fun update_price_feed(
        admin: &signer, 
        pair: String,
        price: u128, 
        confidence: u128
    ) acquires State, PriceBoard {

    }

    /* 
        Returns the latest price as long as it is attested within the default maximum attestation 
        duration. The default maximum attestation duration is defined by the 
        MAXIMUM_FRESH_DURATION_SECONDS constant. Abort if the price is stale or if the pair does
        not exist.
        @param pair - id of the coin pair being updated
        @return - the price of the pair along with the confidence
    */
    public fun get_price(pair: String): Price acquires PriceBoard {

    }

    /* 
        Returns the latest price as long as it is attested no later than maximum_age_seconds ago.
        Abort if the price is stale or if the pair does not exist.
        @param pair - id of the coin pair being updated
        @param maximum_age_seconds - the maximum age of the price in seconds the request price can be
        @return - the price of the pair along with the confidence
    */
    public fun get_price_no_older_than(pair: String, maximum_age_seconds: u64): Price 
    acquires PriceBoard {
        
    }

    /* 
        Returns the latest price regardless of when it was attested. Abort if the pair does not
        exist.
        @param pair - id of the coin pair being updated
        @return - the price of the pair along with the confidence, and the timestamp of when the 
                    the price was attested
    */
    public fun get_price_unsafe(pair: String): (Price, u64) acquires PriceBoard {
        
    }

    //==============================================================================================
    // Helper functions
    //==============================================================================================
    
    //==============================================================================================
    // Validation functions
    //==============================================================================================

    //==============================================================================================
    // Tests - DO NOT MODIFY
    //==============================================================================================

    #[test(admin = @overmind, user = @0xA)]
    fun test_init_module_success(
        admin: &signer, 
        user: &signer
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let expected_resource_account_address = account::create_resource_address(&@overmind, b"price oracle");

        assert!(exists<PriceBoard>(expected_resource_account_address), 0);
        assert!(exists<State>(expected_resource_account_address), 0);

        let state = borrow_global<State>(expected_resource_account_address);
        assert!(
            account::get_signer_capability_address(&state.signer_cap) == expected_resource_account_address,
            0
        );

        assert!(event::counter(&state.price_feed_updated_event) == 0, 0);
    }

    #[test(admin = @overmind, user = @0xA)]
    fun test_update_price_feed_success_add_one_new_pair_zero_confidence_value(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        let pair = string::utf8(b"APT/USDT");
        let apt_usd = 691000000;
        let usdt_usd = 99880000;
        let apt_usdt = apt_usd * 100000000 / usdt_usd;
        let confidence = 0;


        update_price_feed(
            admin, 
            pair, 
            apt_usdt, 
            confidence
        );

        let price_board = borrow_global<PriceBoard>(resource_account_address);
        let prices = &price_board.prices;
        assert!(
            table::contains(prices, pair),
            0
        );
        let PriceFeed {
            latest_attestation_timestamp_seconds: actual_attestation_timestamp,
            pair: actual_pair, 
            price: Price { price: actual_price, confidence: actual_confidence }
        } = table::borrow(prices, pair);
        assert!(
            *actual_attestation_timestamp == timestamp::now_seconds(),
            0   
        );
        assert!(
            *actual_pair == pair,
            0
        );
        assert!(
            *actual_price == apt_usdt,
            0
        );
        assert!(
            *actual_confidence == confidence,
            0
        );

        let state = borrow_global<State>(resource_account_address);
        assert!(event::counter(&state.price_feed_updated_event) == 1, 0);
    }

    #[test(admin = @overmind, user = @0xA)]
    fun test_update_price_feed_success_add_one_new_pair_non_zero_confidence_value(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        let pair = string::utf8(b"APT/USDT");
        let apt_usd = 691000000;
        let usdt_usd = 99880000;
        let apt_usdt = apt_usd * 100000000 / usdt_usd;
        let confidence = 00010000;


        update_price_feed(
            admin, 
            pair, 
            apt_usdt, 
            confidence
        );

        let price_board = borrow_global<PriceBoard>(resource_account_address);
        let prices = &price_board.prices;
        assert!(
            table::contains(prices, pair),
            0
        );
        let PriceFeed {
            latest_attestation_timestamp_seconds: actual_attestation_timestamp,
            pair: actual_pair, 
            price: Price { price: actual_price, confidence: actual_confidence }
        } = table::borrow(prices, pair);
        assert!(
            *actual_attestation_timestamp == timestamp::now_seconds(),
            0   
        );
        assert!(
            *actual_pair == pair,
            0
        );
        assert!(
            *actual_price == apt_usdt,
            0
        );
        assert!(
            *actual_confidence == confidence,
            0
        );
        let state = borrow_global<State>(resource_account_address);
        assert!(event::counter(&state.price_feed_updated_event) == 1, 0);
    }

    #[test(admin = @overmind, user = @0xA)]
    fun test_update_price_feed_success_add_multiple_new_pairs(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        let apt_usd = 691000000;     // 6.91
        let usdt_usd = 99880000;     // 0.9988 
        let btc_usd = 2930156123456; // 29301.56123456
        let eth_usd = 183835123456;  // 1838.35123456
        let sol_usd = 2462123456;    // 24.62123456

        let pair_1 = string::utf8(b"APT/USDT");
        let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
        let confidence_1 = 00010000;
        update_price_feed(
            admin, 
            pair_1, 
            apt_usdt_1, 
            confidence_1
        );

        let pair_2 = string::utf8(b"BTC/APT");
        let btc_apt_2 = btc_usd * 100000000 / apt_usd;
        let confidence_2 = 00010000;
        update_price_feed(
            admin, 
            pair_2, 
            btc_apt_2, 
            confidence_2
        );

        let pair_3 = string::utf8(b"ETH/SOL");
        let eth_apt_3 = eth_usd * 100000000 / sol_usd;
        let confidence_3 = 00010000;
        update_price_feed(
            admin, 
            pair_3, 
            eth_apt_3, 
            confidence_3
        );

        let price_board = borrow_global<PriceBoard>(resource_account_address);
        let prices = &price_board.prices;

        assert!(
            table::contains(prices, pair_1),
            0
        );
        let PriceFeed {
            latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
            pair: actual_pair_1, 
            price: Price { price: actual_price_1, confidence: actual_confidence_1 }
        } = table::borrow(prices, pair_1);
        assert!(
            *actual_attestation_timestamp_1 == timestamp::now_seconds(),
            0   
        );
        assert!(
            *actual_pair_1 == pair_1,
            0
        );
        assert!(
            *actual_price_1 == apt_usdt_1,
            0
        );
        assert!(
            *actual_confidence_1 == confidence_1,
            0
        );

        assert!(
            table::contains(prices, pair_2),
            0
        );
        let PriceFeed {
            latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
            pair: actual_pair_2, 
            price: Price { price: actual_price_2, confidence: actual_confidence_2 }
        } = table::borrow(prices, pair_2);
        assert!(
            *actual_attestation_timestamp_2 == timestamp::now_seconds(),
            0   
        );
        assert!(
            *actual_pair_2 == pair_2,
            0
        );
        assert!(
            *actual_price_2 == btc_apt_2,
            0
        );
        assert!(
            *actual_confidence_2 == confidence_2,
            0
        );

        assert!(
            table::contains(prices, pair_3),
            0
        );
        let PriceFeed {
            latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
            pair: actual_pair_3, 
            price: Price { price: actual_price_3, confidence: actual_confidence_3 }
        } = table::borrow(prices, pair_3);
        assert!(
            *actual_attestation_timestamp_3 == timestamp::now_seconds(),
            0   
        );
        assert!(
            *actual_pair_3 == pair_3,
            0
        );
        assert!(
            *actual_price_3 == eth_apt_3,
            0
        );
        assert!(
            *actual_confidence_3 == confidence_3,
            0
        );

        let state = borrow_global<State>(resource_account_address);
        assert!(event::counter(&state.price_feed_updated_event) == 3, 0);
    }

    #[test(admin = @overmind, user = @0xA)]
    fun test_update_price_feed_success_update_existing_pair(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        {
            let apt_usd = 691000000;     // 6.91
            let usdt_usd = 99880000;     // 0.9988 
            let btc_usd = 2930156123456; // 29301.56123456
            let eth_usd = 183835123456;  // 1838.35123456
            let sol_usd = 2462123456;    // 24.62123456

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010000;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00010000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 00010000;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        {
            let apt_usd = 691000000;     // 6.91
            let btc_usd = 3930156123456; // 29301.56123456

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00010000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );
        };

        let state = borrow_global<State>(resource_account_address);
        assert!(event::counter(&state.price_feed_updated_event) == 4, 0);
    }

    #[test(admin = @overmind, user = @0xA)]
    fun test_update_price_feed_success_update_existing_pairs(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        // Create new pair price feeds
        {
            let apt_usd = 691000000;     // 6.91
            let usdt_usd = 99880000;     // 0.9988 
            let btc_usd = 2930156123456; // 29301.56123456
            let eth_usd = 183835123456;  // 1838.35123456
            let sol_usd = 2462123456;    // 24.62123456

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010000;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00010000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 00010000;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        // Update price feeds
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;    

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010000;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00010000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 00010000;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        let state = borrow_global<State>(resource_account_address);
        assert!(event::counter(&state.price_feed_updated_event) == 6, 0);
    }

    #[test(admin = @overmind, user = @0xA)]
    #[expected_failure(abort_code = ErrorCodeForAllAborts, location = Self)]
    fun test_update_price_feed_failure_caller_not_admin(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        let pair = string::utf8(b"APT/USDT");
        let apt_usd = 691000000;
        let usdt_usd = 99880000;
        let apt_usdt = apt_usd * 100000000 / usdt_usd;
        let confidence = 0;


        update_price_feed(
            user, 
            pair, 
            apt_usdt, 
            confidence
        );

        let price_board = borrow_global<PriceBoard>(resource_account_address);
        let prices = &price_board.prices;
        assert!(
            table::contains(prices, pair),
            0
        );
        let PriceFeed {
            latest_attestation_timestamp_seconds: actual_attestation_timestamp,
            pair: actual_pair, 
            price: Price { price: actual_price, confidence: actual_confidence }
        } = table::borrow(prices, pair);
        assert!(
            *actual_attestation_timestamp == timestamp::now_seconds(),
            0   
        );
        assert!(
            *actual_pair == pair,
            0
        );
        assert!(
            *actual_price == apt_usdt,
            0
        );
        assert!(
            *actual_confidence == confidence,
            0
        );
    }

    #[test(admin = @overmind, user = @0xA)]
    fun test_get_price_success_one_price_within_duration(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        timestamp::fast_forward_seconds(60 * 60);

        // Create new pair price feeds
        {
            let apt_usd = 691000000;     // 6.91
            let usdt_usd = 99880000;     // 0.9988 
            let btc_usd = 2930156123456; // 29301.56123456
            let eth_usd = 183835123456;  // 1838.35123456
            let sol_usd = 2462123456;    // 24.62123456

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010000;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00010000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 00010000;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 3 / 2);

        // Update price feeds
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;    

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010890;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00200000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 10000840120;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 2);

        // Get price 
        {

            let apt_usd = 691000000;
            let usdt_usd = 100880000;       

            let confidence_1 = 00010890;

            let pair_1 = string::utf8(b"APT/USDT");
            let expected_price_1 = apt_usd * 100000000 / usdt_usd;

            let price_feed_1 = get_price(pair_1);
            assert!(
                price_feed_1.price == expected_price_1,
                0
            );
            assert!(
                price_feed_1.confidence == confidence_1,
                0
            );
        };

        let state = borrow_global<State>(resource_account_address);
        assert!(event::counter(&state.price_feed_updated_event) == 6, 0);
    }

    #[test(admin = @overmind, user = @0xA)]
    #[expected_failure(abort_code = ErrorCodeForAllAborts, location = Self)]
    fun test_get_price_failure_pair_does_not_exist(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        timestamp::fast_forward_seconds(60 * 60);

        // Create new pair price feeds
        {
            let apt_usd = 691000000;     // 6.91
            let usdt_usd = 99880000;     // 0.9988 
            let btc_usd = 2930156123456; // 29301.56123456
            let eth_usd = 183835123456;  // 1838.35123456
            let sol_usd = 2462123456;    // 24.62123456

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010000;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00010000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 00010000;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 3 / 2);

        // Update price feeds
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;    

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010890;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00200000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 10000840120;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 2);

        // Get price 
        {

            let apt_usd = 691000000;
            let usdt_usd = 100880000;     

            let confidence_1 = 00010890;

            let pair_1 = string::utf8(b"APT/USDC");
            let expected_price_1 = apt_usd * 100000000 / usdt_usd;

            let price_feed_1 = get_price(pair_1);
            assert!(
                price_feed_1.price == expected_price_1,
                0
            );
            assert!(
                price_feed_1.confidence == confidence_1,
                0
            );
        };

        let state = borrow_global<State>(resource_account_address);
        assert!(event::counter(&state.price_feed_updated_event) == 3, 0);
    }

    #[test(admin = @overmind, user = @0xA)]
    #[expected_failure(abort_code = ErrorCodeForAllAborts, location = Self)]
    fun test_get_price_failure_price_is_stale(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        timestamp::fast_forward_seconds(60 * 60);

        // Create new pair price feeds
        {
            let apt_usd = 691000000;     // 6.91
            let usdt_usd = 99880000;     // 0.9988 
            let btc_usd = 2930156123456; // 29301.56123456
            let eth_usd = 183835123456;  // 1838.35123456
            let sol_usd = 2462123456;    // 24.62123456

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010000;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00010000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 00010000;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 3 / 2);

        // Update price feeds
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;    

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010890;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00200000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 10000840120;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 3 + 1);

        // Get price 
        {

            let apt_usd = 691000000;
            let usdt_usd = 100880000;     

            let confidence_1 = 00010890;

            let pair_1 = string::utf8(b"APT/USDT");
            let expected_price_1 = apt_usd * 100000000 / usdt_usd;

            let price_feed_1 = get_price(pair_1);
            assert!(
                price_feed_1.price == expected_price_1,
                0
            );
            assert!(
                price_feed_1.confidence == confidence_1,
                0
            );
        };
    }

    #[test(admin = @overmind, user = @0xA)]
    fun test_get_price_no_older_than_success_multiple_prices_within_duration(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        timestamp::fast_forward_seconds(60 * 60 * 1000);

        // Create new pair price feeds
        {
            let apt_usd = 691000000;     // 6.91
            let usdt_usd = 99880000;     // 0.9988 
            let btc_usd = 2930156123456; // 29301.56123456
            let eth_usd = 183835123456;  // 1838.35123456
            let sol_usd = 2462123456;    // 24.62123456

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010000;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00010000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 00010000;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 5 / 2);

        // Update price feeds
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;    

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010890;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00200000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 10000840120;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 4);

        // Get price 
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;   

            let confidence_1 = 00010890;
            let confidence_2 = 00200000;
            let confidence_3 = 10000840120;

            let pair_1 = string::utf8(b"APT/USDT");
            let expected_price_1 = apt_usd * 100000000 / usdt_usd;
            let price_feed_1 = get_price_no_older_than(pair_1, 60 * 60 * 5);
            assert!(
                price_feed_1.price == expected_price_1,
                0
            );
            assert!(
                price_feed_1.confidence == confidence_1,
                0
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let expected_price_3 = eth_usd * 100000000 / sol_usd;
            let price_feed_3 = get_price_no_older_than(pair_3, 60 * 60 * 5);
            assert!(
                price_feed_3.price == expected_price_3,
                0
            );
            assert!(
                price_feed_3.confidence == confidence_3,
                0
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let expected_price_2 = btc_usd * 100000000 / apt_usd;
            let price_feed_2 = get_price_no_older_than(pair_2, 60 * 60 * 5);
            assert!(
                price_feed_2.price == expected_price_2,
                0
            );
            assert!(
                price_feed_2.confidence == confidence_2,
                0
            );
        };

        let state = borrow_global<State>(resource_account_address);
        assert!(event::counter(&state.price_feed_updated_event) == 6, 0);
    }

    #[test(admin = @overmind, user = @0xA)]
    #[expected_failure(abort_code = ErrorCodeForAllAborts, location = Self)]
    fun test_get_price_no_older_than_failure_price_is_stale(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        timestamp::fast_forward_seconds(60 * 60 * 1000);

        // Create new pair price feeds
        {
            let apt_usd = 691000000;     // 6.91
            let usdt_usd = 99880000;     // 0.9988 
            let btc_usd = 2930156123456; // 29301.56123456
            let eth_usd = 183835123456;  // 1838.35123456
            let sol_usd = 2462123456;    // 24.62123456

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010000;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00010000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 00010000;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 5 / 2);

        // Update price feeds
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;    

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010890;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00200000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 10000840120;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 3 + 1);

        // Get price 
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;   

            let confidence_1 = 00010890;
            let confidence_2 = 00200000;
            let confidence_3 = 10000840120;

            let pair_1 = string::utf8(b"APT/USDT");
            let expected_price_1 = apt_usd * 100000000 / usdt_usd;
            let price_feed_1 = get_price_no_older_than(pair_1, 60 * 60 * 5 / 2);
            assert!(
                price_feed_1.price == expected_price_1,
                0
            );
            assert!(
                price_feed_1.confidence == confidence_1,
                0
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let expected_price_3 = eth_usd * 100000000 / sol_usd;
            let price_feed_3 = get_price_no_older_than(pair_3, 60 * 60 * 5 / 2);
            assert!(
                price_feed_3.price == expected_price_3,
                0
            );
            assert!(
                price_feed_3.confidence == confidence_3,
                0
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let expected_price_2 = btc_usd * 100000000 / apt_usd;
            let price_feed_2 = get_price_no_older_than(pair_2, 60 * 60 * 5 / 2);
            assert!(
                price_feed_2.price == expected_price_2,
                0
            );
            assert!(
                price_feed_2.confidence == confidence_2,
                0
            );
        };
    }

    #[test(admin = @overmind, user = @0xA)]
    #[expected_failure(abort_code = ErrorCodeForAllAborts, location = Self)]
    fun test_get_price_no_older_than_failure_pair_does_not_exist(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        timestamp::fast_forward_seconds(60 * 60 * 1000);

        // Create new pair price feeds
        {
            let apt_usd = 691000000;     // 6.91
            let usdt_usd = 99880000;     // 0.9988 
            let btc_usd = 2930156123456; // 29301.56123456
            let eth_usd = 183835123456;  // 1838.35123456
            let sol_usd = 2462123456;    // 24.62123456

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010000;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00010000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 00010000;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 5 / 2);

        // Update price feeds
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;    

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010890;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00200000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 10000840120;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 5 / 2);

        // Get price 
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;   

            let confidence_1 = 00010890;
            let confidence_2 = 00200000;
            let confidence_3 = 10000840120;

            let pair_1 = string::utf8(b"APT/USDT");
            let expected_price_1 = apt_usd * 100000000 / usdt_usd;
            let price_feed_1 = get_price_no_older_than(pair_1, 60 * 60 * 5 / 2);
            assert!(
                price_feed_1.price == expected_price_1,
                0
            );
            assert!(
                price_feed_1.confidence == confidence_1,
                0
            );

            let pair_3 = string::utf8(b"APT/SOL");
            let expected_price_3 = eth_usd * 100000000 / sol_usd;
            let price_feed_3 = get_price_no_older_than(pair_3, 60 * 60 * 5 / 2);
            assert!(
                price_feed_3.price == expected_price_3,
                0
            );
            assert!(
                price_feed_3.confidence == confidence_3,
                0
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let expected_price_2 = btc_usd * 100000000 / apt_usd;
            let price_feed_2 = get_price_no_older_than(pair_2, 60 * 60 * 5 / 2);
            assert!(
                price_feed_2.price == expected_price_2,
                0
            );
            assert!(
                price_feed_2.confidence == confidence_2,
                0
            );
        };

        let state = borrow_global<State>(resource_account_address);
        assert!(event::counter(&state.price_feed_updated_event) == 3, 0);
    }

    #[test(admin = @overmind, user = @0xA)]
    fun test_get_price_success_multiple_prices_within_duration(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        timestamp::fast_forward_seconds(60 * 60 * 1000);

        // Create new pair price feeds
        {
            let apt_usd = 691000000;     // 6.91
            let usdt_usd = 99880000;     // 0.9988 
            let btc_usd = 2930156123456; // 29301.56123456
            let eth_usd = 183835123456;  // 1838.35123456
            let sol_usd = 2462123456;    // 24.62123456

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010000;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00010000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 00010000;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 5 / 2);

        // Update price feeds
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;    

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010890;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00200000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 10000840120;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 3 / 2);

        // Get price 
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;   

            let confidence_1 = 00010890;
            let confidence_2 = 00200000;
            let confidence_3 = 10000840120;

            let pair_1 = string::utf8(b"APT/USDT");
            let expected_price_1 = apt_usd * 100000000 / usdt_usd;
            let price_feed_1 = get_price(pair_1);
            assert!(
                price_feed_1.price == expected_price_1,
                0
            );
            assert!(
                price_feed_1.confidence == confidence_1,
                0
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let expected_price_3 = eth_usd * 100000000 / sol_usd;
            let price_feed_3 = get_price(pair_3);
            assert!(
                price_feed_3.price == expected_price_3,
                0
            );
            assert!(
                price_feed_3.confidence == confidence_3,
                0
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let expected_price_2 = btc_usd * 100000000 / apt_usd;
            let price_feed_2 = get_price(pair_2);
            assert!(
                price_feed_2.price == expected_price_2,
                0
            );
            assert!(
                price_feed_2.confidence == confidence_2,
                0
            );
        };

        let state = borrow_global<State>(resource_account_address);
        assert!(event::counter(&state.price_feed_updated_event) == 6, 0);
    }

    #[test(admin = @overmind, user = @0xA)]
    fun test_get_price_unsafe_success_multiple_prices_within_duration(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        timestamp::fast_forward_seconds(60 * 60 * 1000);

        // Create new pair price feeds
        {
            let apt_usd = 691000000;     // 6.91
            let usdt_usd = 99880000;     // 0.9988 
            let btc_usd = 2930156123456; // 29301.56123456
            let eth_usd = 183835123456;  // 1838.35123456
            let sol_usd = 2462123456;    // 24.62123456

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010000;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00010000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 00010000;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 5 / 2);

        // Update price feeds
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;    

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010890;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00200000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 10000840120;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 3 / 2);

        // Get price 
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;   

            let confidence_1 = 00010890;
            let confidence_2 = 00200000;
            let confidence_3 = 10000840120;

            let pair_1 = string::utf8(b"APT/USDT");
            let expected_price_1 = apt_usd * 100000000 / usdt_usd;
            let (price_feed_1, actual_attestation_timestamp_1) = get_price_unsafe(pair_1);
            assert!(
                price_feed_1.price == expected_price_1,
                0
            );
            assert!(
                price_feed_1.confidence == confidence_1,
                0
            );
            assert!(
                actual_attestation_timestamp_1 == timestamp::now_seconds() - 60 * 60 * 3 / 2,
                0
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let expected_price_3 = eth_usd * 100000000 / sol_usd;
            let (price_feed_3, actual_attestation_timestamp_3) = get_price_unsafe(pair_3);
            assert!(
                price_feed_3.price == expected_price_3,
                0
            );
            assert!(
                price_feed_3.confidence == confidence_3,
                0
            );
            assert!(
                actual_attestation_timestamp_3 == timestamp::now_seconds() - 60 * 60 * 3 / 2,
                0
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let expected_price_2 = btc_usd * 100000000 / apt_usd;
            let (price_feed_2, actual_attestation_timestamp_2) = get_price_unsafe(pair_2);
            assert!(
                price_feed_2.price == expected_price_2,
                0
            );
            assert!(
                price_feed_2.confidence == confidence_2,
                0
            );
            assert!(
                actual_attestation_timestamp_2 == timestamp::now_seconds() - 60 * 60 * 3 / 2,
                0
            );
        };

        let state = borrow_global<State>(resource_account_address);
        assert!(event::counter(&state.price_feed_updated_event) == 6, 0);
    }

    #[test(admin = @overmind, user = @0xA)]
    fun test_get_price_unsafe_success_multiple_prices_just_outside_default_duration(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        timestamp::fast_forward_seconds(60 * 60 * 1000);

        // Create new pair price feeds
        {
            let apt_usd = 691000000;     // 6.91
            let usdt_usd = 99880000;     // 0.9988 
            let btc_usd = 2930156123456; // 29301.56123456
            let eth_usd = 183835123456;  // 1838.35123456
            let sol_usd = 2462123456;    // 24.62123456

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010000;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00010000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 00010000;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 5 / 2);

        // Update price feeds
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;    

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010890;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00200000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 10000840120;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 3 + 1);

        // Get price 
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;   

            let confidence_1 = 00010890;
            let confidence_2 = 00200000;
            let confidence_3 = 10000840120;

            let pair_1 = string::utf8(b"APT/USDT");
            let expected_price_1 = apt_usd * 100000000 / usdt_usd;
            let (price_feed_1, _) = get_price_unsafe(pair_1);
            assert!(
                price_feed_1.price == expected_price_1,
                0
            );
            assert!(
                price_feed_1.confidence == confidence_1,
                0
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let expected_price_3 = eth_usd * 100000000 / sol_usd;
            let (price_feed_3, _) = get_price_unsafe(pair_3);
            assert!(
                price_feed_3.price == expected_price_3,
                0
            );
            assert!(
                price_feed_3.confidence == confidence_3,
                0
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let expected_price_2 = btc_usd * 100000000 / apt_usd;
            let (price_feed_2, _) = get_price_unsafe(pair_2);
            assert!(
                price_feed_2.price == expected_price_2,
                0
            );
            assert!(
                price_feed_2.confidence == confidence_2,
                0
            );
        };

        let state = borrow_global<State>(resource_account_address);
        assert!(event::counter(&state.price_feed_updated_event) == 6, 0);
    }

    #[test(admin = @overmind, user = @0xA)]
    fun test_get_price_unsafe_success_multiple_prices_much_outside_default_duration(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        timestamp::fast_forward_seconds(60 * 60 * 1000);

        // Create new pair price feeds
        {
            let apt_usd = 691000000;     // 6.91
            let usdt_usd = 99880000;     // 0.9988 
            let btc_usd = 2930156123456; // 29301.56123456
            let eth_usd = 183835123456;  // 1838.35123456
            let sol_usd = 2462123456;    // 24.62123456

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010000;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00010000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 00010000;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 5 / 2);

        // Update price feeds
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;    

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010890;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00200000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 10000840120;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 9);

        // Get price 
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;   

            let confidence_1 = 00010890;
            let confidence_2 = 00200000;
            let confidence_3 = 10000840120;

            let pair_1 = string::utf8(b"APT/USDT");
            let expected_price_1 = apt_usd * 100000000 / usdt_usd;
            let (price_feed_1, _) = get_price_unsafe(pair_1);
            assert!(
                price_feed_1.price == expected_price_1,
                0
            );
            assert!(
                price_feed_1.confidence == confidence_1,
                0
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let expected_price_3 = eth_usd * 100000000 / sol_usd;
            let (price_feed_3, _) = get_price_unsafe(pair_3);
            assert!(
                price_feed_3.price == expected_price_3,
                0
            );
            assert!(
                price_feed_3.confidence == confidence_3,
                0
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let expected_price_2 = btc_usd * 100000000 / apt_usd;
            let (price_feed_2, _) = get_price_unsafe(pair_2);
            assert!(
                price_feed_2.price == expected_price_2,
                0
            );
            assert!(
                price_feed_2.confidence == confidence_2,
                0
            );
        };

        let state = borrow_global<State>(resource_account_address);
        assert!(event::counter(&state.price_feed_updated_event) == 6, 0);
    }

    #[test(admin = @overmind, user = @0xA)]
    #[expected_failure(abort_code = ErrorCodeForAllAborts, location = Self)]
    fun test_get_price_unsafe_failure_pair_does_not_exist(
        admin: &signer,
        user: &signer
    ) acquires State, PriceBoard {
        let admin_address = signer::address_of(admin);
        let user_address = signer::address_of(user);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(user_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);

        init_module(admin);

        let resource_account_address = account::create_resource_address(&@overmind, SEED);

        timestamp::fast_forward_seconds(60 * 60 * 1000);

        // Create new pair price feeds
        {
            let apt_usd = 691000000;     // 6.91
            let usdt_usd = 99880000;     // 0.9988 
            let btc_usd = 2930156123456; // 29301.56123456
            let eth_usd = 183835123456;  // 1838.35123456
            let sol_usd = 2462123456;    // 24.62123456

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010000;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00010000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 00010000;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 5 / 2);

        // Update price feeds
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;    

            let pair_1 = string::utf8(b"APT/USDT");
            let apt_usdt_1 = apt_usd * 100000000 / usdt_usd;
            let confidence_1 = 00010890;
            update_price_feed(
                admin, 
                pair_1, 
                apt_usdt_1, 
                confidence_1
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let btc_apt_2 = btc_usd * 100000000 / apt_usd;
            let confidence_2 = 00200000;
            update_price_feed(
                admin, 
                pair_2, 
                btc_apt_2, 
                confidence_2
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let eth_apt_3 = eth_usd * 100000000 / sol_usd;
            let confidence_3 = 10000840120;
            update_price_feed(
                admin, 
                pair_3, 
                eth_apt_3, 
                confidence_3
            );

            let price_board = borrow_global<PriceBoard>(resource_account_address);
            let prices = &price_board.prices;

            assert!(
                table::contains(prices, pair_1),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_1,
                pair: actual_pair_1, 
                price: Price { price: actual_price_1, confidence: actual_confidence_1 }
            } = table::borrow(prices, pair_1);
            assert!(
                *actual_attestation_timestamp_1 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_1 == pair_1,
                0
            );
            assert!(
                *actual_price_1 == apt_usdt_1,
                0
            );
            assert!(
                *actual_confidence_1 == confidence_1,
                0
            );

            assert!(
                table::contains(prices, pair_2),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_2,
                pair: actual_pair_2, 
                price: Price { price: actual_price_2, confidence: actual_confidence_2 }
            } = table::borrow(prices, pair_2);
            assert!(
                *actual_attestation_timestamp_2 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_2 == pair_2,
                0
            );
            assert!(
                *actual_price_2 == btc_apt_2,
                0
            );
            assert!(
                *actual_confidence_2 == confidence_2,
                0
            );

            assert!(
                table::contains(prices, pair_3),
                0
            );
            let PriceFeed {
                latest_attestation_timestamp_seconds: actual_attestation_timestamp_3,
                pair: actual_pair_3, 
                price: Price { price: actual_price_3, confidence: actual_confidence_3 }
            } = table::borrow(prices, pair_3);
            assert!(
                *actual_attestation_timestamp_3 == timestamp::now_seconds(),
                0   
            );
            assert!(
                *actual_pair_3 == pair_3,
                0
            );
            assert!(
                *actual_price_3 == eth_apt_3,
                0
            );
            assert!(
                *actual_confidence_3 == confidence_3,
                0
            );
        };

        timestamp::fast_forward_seconds(60 * 60 * 9);

        // Get price 
        {
            let apt_usd = 691000000;
            let usdt_usd = 100880000;     
            let btc_usd = 1930156123456; 
            let eth_usd = 193835123456;  
            let sol_usd = 2062123456;   

            let confidence_1 = 00010890;
            let confidence_2 = 00200000;
            let confidence_3 = 10000840120;

            let pair_1 = string::utf8(b"APT");
            let expected_price_1 = apt_usd * 100000000 / usdt_usd;
            let (price_feed_1, _) = get_price_unsafe(pair_1);
            assert!(
                price_feed_1.price == expected_price_1,
                0
            );
            assert!(
                price_feed_1.confidence == confidence_1,
                0
            );

            let pair_3 = string::utf8(b"ETH/SOL");
            let expected_price_3 = eth_usd * 100000000 / sol_usd;
            let (price_feed_3, _) = get_price_unsafe(pair_3);
            assert!(
                price_feed_3.price == expected_price_3,
                0
            );
            assert!(
                price_feed_3.confidence == confidence_3,
                0
            );

            let pair_2 = string::utf8(b"BTC/APT");
            let expected_price_2 = btc_usd * 100000000 / apt_usd;
            let (price_feed_2, _) = get_price_unsafe(pair_2);
            assert!(
                price_feed_2.price == expected_price_2,
                0
            );
            assert!(
                price_feed_2.confidence == confidence_2,
                0
            );
        };

        let state = borrow_global<State>(resource_account_address);
        assert!(event::counter(&state.price_feed_updated_event) == 3, 0);
    }
}
