use lazy_static::{initialize, lazy_static};
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
#[module = "UserAgent"]
struct UserAgent {
    pub family: String,
    pub major: Option<String>,
    pub minor: Option<String>,
    pub patch: Option<String>,
}
impl From<uaparser::UserAgent<'_>> for UserAgent {
    fn from(ua: uaparser::UserAgent) -> Self {
        Self {
            family: ua.family.to_string(),
            major: ua.major.map(|x| x.to_string()),
            minor: ua.minor.map(|x| x.to_string()),
            patch: ua.patch.map(|x| x.to_string()),
        }
    }
}

#[derive(Debug, NifStruct)]
#[module = "OS"]
struct OS {
    family: String,
    major: Option<String>,
    minor: Option<String>,
    patch: Option<String>,
    patch_minor: Option<String>,
}
impl From<uaparser::OS<'_>> for OS {
    fn from(os: uaparser::OS<'_>) -> Self {
        Self {
            family: os.family.to_string(),
            major: os.major.map(|major| major.to_string()),
            minor: os.minor.map(|minor| minor.to_string()),
            patch: os.patch.map(|patch| patch.to_string()),
            patch_minor: os.patch_minor.map(|patch_minor| patch_minor.to_string()),
        }
    }
}

#[derive(Debug, NifStruct)]
#[module = "Device"]
struct Device {
    family: String,
    brand: Option<String>,
    model: Option<String>,
}
impl From<uaparser::Device<'_>> for Device {
    fn from(device: uaparser::Device) -> Self {
        Self {
            family: device.family.to_string(),
            brand: device.brand.map(|brand| brand.to_string()),
            model: device.model.map(|model| model.to_string()),
        }
    }
}

#[derive(Debug, NifStruct)]
#[module = "Client"]
struct Client {
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

rustler::init!("Elixir.UAParser", [add, load, parse]);
