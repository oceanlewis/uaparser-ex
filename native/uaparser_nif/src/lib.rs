mod model;
use lazy_static::{initialize, lazy_static};
use uaparser::{Parser, UserAgentParser};

use crate::model::Client;

mod atoms {
    rustler::atoms! {
        ok
    }
}

#[rustler::nif]
fn add(a: i64, b: i64) -> i64 {
    a + b
}

const REGEXES: &[u8] = include_bytes!("../resources/regexes.yaml");

lazy_static! {
    static ref UA_PARSER: UserAgentParser =
        UserAgentParser::from_bytes(REGEXES).expect("UserAgentParser initialization failed");
}

#[rustler::nif]
fn load() -> rustler::Atom {
    initialize(&UA_PARSER);
    atoms::ok()
}

#[rustler::nif]
fn parse(user_agent: String) -> Client {
    Client::from(UA_PARSER.parse(&user_agent))
}

#[rustler::nif]
fn parse_all(user_agents: Vec<String>) -> Vec<Client> {
    user_agents
        .iter()
        .map(|ua| Client::from(UA_PARSER.parse(ua)))
        .collect()
}

rustler::init!("Elixir.UAParserRS", [add, load, parse, parse_all]);

#[cfg(test)]
mod tests {
    use std::time::Instant;

    use uaparser::{Parser, UserAgentParser};

    fn time(f: impl Fn() -> ()) {
        let now = Instant::now();

        f();

        println!("== Seconds elapsed: {} ==", now.elapsed().as_secs());
    }
    #[test]
    fn benchmark() {
        let user_agents: Vec<String> = include_str!("../../../test/resources/useragents.csv")
            .split("\n")
            .map(ToString::to_string)
            .collect();

        let regexes = include_bytes!("../resources/regexes.yaml");
        let ua_parser = UserAgentParser::from_bytes(regexes).unwrap();

        time(|| {
            for _ in 0..=15 {
                for ua in user_agents.iter() {
                    ua_parser.parse_user_agent(ua);
                }
            }
        })
    }
}
