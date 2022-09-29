mod model;

use lazy_static::{initialize, lazy_static};
use model::{Device, UserAgent, OS};
use rustler::NifStruct;
use uaparser::{Parser, UserAgentParser};

mod atoms {
    rustler::atoms! {
        ok
    }
}

const REGEXES: &[u8] = include_bytes!("../resources/regexes.yaml");

lazy_static! {
    static ref UA_PARSER: UserAgentParser =
        UserAgentParser::from_bytes(REGEXES).expect("UserAgentParser initialization failed");
}

#[derive(Debug, NifStruct)]
#[module = "Client"]
pub struct Client {
    pub os: OS,
    pub device: Device,
    pub user_agent: UserAgent,
}
impl From<uaparser::Client<'_>> for Client {
    fn from(client: uaparser::Client) -> Self {
        Self {
            os: OS::from(client.os),
            device: Device::from(client.device),
            user_agent: UserAgent::from(client.user_agent),
        }
    }
}

#[rustler::nif]
fn add(a: i64, b: i64) -> i64 {
    a + b
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

rustler::init!("Elixir.UAParser", [add, load, parse, parse_all]);

#[cfg(test)]
mod tests {
    use std::time::Instant;

    fn time(f: impl Fn() -> ()) {
        let now = Instant::now();

        f();

        println!("Seconds elapsed: {}", now.elapsed().as_secs());
    }
    #[test]
    fn benchmark() {
        let user_agents = include_str!("../test/resouces/useragents.csv");

        time(|| for _ in 0..=15 {})
    }
}
