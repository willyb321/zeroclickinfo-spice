#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Spice;
use DDG::Test::Location;
use DDG::Request;

ddg_spice_test(
    [ 'DDG::Spice::Cryptocurrency' ],
    'ltc ftc' => test_spice(
        '/js/spice/cryptocurrency/ticker/ltc-ftc/1',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),
    '500 ltc ftc' => test_spice(
        '/js/spice/cryptocurrency/ticker/ltc-ftc/500',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),
    'ltc 500 ftc' => test_spice(
        '/js/spice/cryptocurrency/ticker/ftc-ltc/500',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),
    '500 litecoin to ftc' => test_spice(
        '/js/spice/cryptocurrency/ticker/ltc-ftc/500',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),
    'litecoin vs. bitcoin' => test_spice(
        '/js/spice/cryptocurrency/ticker/ltc-btc/1',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),
    'convert litecoin to 30 ftc' => test_spice(
        '/js/spice/cryptocurrency/ticker/ftc-ltc/30',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),
    'eth to usd' => test_spice(
        '/js/spice/cryptocurrency/ticker/eth-usd/1',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),
    'etherium to jpy' => test_spice(
        '/js/spice/cryptocurrency/ticker/eth-jpy/1',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),
    'ethereum to ltc' => test_spice(
        '/js/spice/cryptocurrency/ticker/eth-ltc/1',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),
    'ethereum coin to ltc' => test_spice(
        '/js/spice/cryptocurrency/ticker/eth-ltc/1',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),
    'etherium to ltc' => test_spice(
        '/js/spice/cryptocurrency/ticker/eth-ltc/1',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),

    # location dependant tests
    DDG::Request->new(
        query_raw => "500 ltc",
        location => test_location("de")
    ) => test_spice(
        '/js/spice/cryptocurrency/ticker/ltc-eur/500',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),

    DDG::Request->new(
        query_raw => "lite coin",
        location => test_location("us")
    ) => test_spice(
        '/js/spice/cryptocurrency/ticker/ltc-usd/1',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),

    DDG::Request->new(
        query_raw => "convert litecoin",
        location => test_location("au")
    ) => test_spice(
        '/js/spice/cryptocurrency/ticker/ltc-btc/1',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),

    # We don't support australian dollars in the ui, so falls back to btc
    DDG::Request->new(
        query_raw => "500 ftc",
        location => test_location("au")
    ) => test_spice(
        '/js/spice/cryptocurrency/ticker/ftc-btc/500',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),

    DDG::Request->new(
        query_raw => "litecoin exchange rate",
        location => test_location("us")
    ) => test_spice(
        '/js/spice/cryptocurrency/ticker/ltc-usd/1',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),

    DDG::Request->new(
        query_raw => "100,000 litecoin",
        location => test_location("in")
    ) => test_spice(
        '/js/spice/cryptocurrency/ticker/ltc-btc/100000',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),

    # Handling the query '1 <cryptocurrency>'. Doesn't trigger unless cryptocurrency is in the top 10 currencies or the cryptocurrency has 'coin' in the name.
    # Should trigger because PPC is in the top 10
    DDG::Request->new(
        query_raw => "1 ppc",
        location => test_location("us")
    ) => test_spice(
        '/js/spice/cryptocurrency/ticker/ppc-usd/1',
        call_type => 'include',
        caller => 'DDG::Spice::Cryptocurrency',
        is_cached => 0
    ),

    # Malformed queries
    'ltc to ltc' => undef,
    'ltc to' => undef,
    # Numbers that shouldn't trigger spice.
    '42' => undef,
    '66' => undef,
    '666' => undef,
    '2015' => undef,
    # Words or acronyms that shouldn't trigger spice.
    'ftc?' => undef,
    'BOOM' => undef,
    'Sloths' => undef,
    # Numbers with ambiguous formatting.
    'convert 200,0000.1.1 ltc into btc' => undef,
    # Other types of conversion
    'convert 32 f to c' => undef,
    # Ambiguous queries.
    '100btc 40ltc' => undef,
    '10 kryp to 10 ltc' => undef,
    # Things that should probably work but it doesn't at the moment.
    'ppc ftc 400' => undef,
    '499 nmc = ? usd' => undef,
    # Irellevant queries
    'convert religion' => undef,
    'what is a cow' => undef,
    'usda loans' => undef,

    # Handled by the Currency Spice.
    'usd to cad' => undef,
    'btc' => undef,
    '500 btc in usd' => undef,
    'canada dollar' => undef,
    '400 euro' => undef,
    '499 us dollar to btc' => undef,
    '25 php to gbp' => undef,
    'convert 1021 gbp to cny'  => undef,
    '1 usd' => undef,
    '1 usd to cad' => undef,

    # We don't want to trigger on date-looking things.
    '2016 feathercoin' => undef,
    # Doesn't trigger with ficticious currencies
    '200 bitcoin waffles to litecoin' => undef,
    'what is 1 euro in crypto donuts' => undef,

    # some random queries not to trigger on
    'how much are featercoins' => undef,
    'buy bitcoins' => undef,
    'btc to supercoin' => undef,
    'litecoin to megacoin' => undef,
    'bitcoin blockchain' => undef,

    # Should not trigger because diode is not in the top 10 and name does not include coin
    '1 diode' => undef,
);

done_testing;
