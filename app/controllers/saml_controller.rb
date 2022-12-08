class SamlController < ApplicationController
skip_before_action :verify_authenticity_token

 def init
  request = OneLogin::RubySaml::Authrequest.new
  redirect_to(request.create(saml_settings))
 end
   
 def consume
  response = OneLogin::RubySaml::Response.new(params[:SAMLResponse], settings: saml_settings)
  request = OneLogin::RubySaml::Authrequest.new
 
    if response.is_valid?
        session[:authenticated] = true
        redirect_to '/homes/new'
      else
        redirect_to(request.create(saml_settings))
      end
 end


 
 private
 def saml_settings
 settings = OneLogin::RubySaml::Settings.new
 #settings = idp_metadata_parser.parse(ENV['OKTA_METADATA'])
 #settings = idp_metadata_parser.parse_remote(ENV['OKTA_METADATA'])idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
 #settings = idp_metadata_parser.parse_remote("http://localhost:3000/saml/metadata")
 
#  settings.idp_cert_multi[:signing] = @settings.idp_cert_multi['signing']
#  settings.idp_cert_multi[:encryption] = @settings.idp_cert_multi['encryption']
 
 
 
 settings.assertion_consumer_service_url = "http://localhost:3000/saml/consume"
 settings.sp_entity_id                   = "SAML-Assertion-Test-Mansi"
 settings.idp_entity_id                  = "http://www.okta.com/exk7jmongujA39zpq5d7"
 settings.idp_sso_service_url            = "https://dev-00488273.okta.com/app/dev-00488273_samltestapp_1/exk7jmongujA39zpq5d7/sso/saml"
 settings.idp_sso_service_binding        = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" # or :post, :redirect
 settings.idp_cert                       = "-----BEGIN CERTIFICATE-----
MIIDqDCCApCgAwIBAgIGAYTsYHQSMA0GCSqGSIb3DQEBCwUAMIGUMQswCQYDVQQGEwJVUzETMBEG
A1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsGA1UECgwET2t0YTEU
MBIGA1UECwwLU1NPUHJvdmlkZXIxFTATBgNVBAMMDGRldi0wMDQ4ODI3MzEcMBoGCSqGSIb3DQEJ
ARYNaW5mb0Bva3RhLmNvbTAeFw0yMjEyMDcxMTM2MzRaFw0zMjEyMDcxMTM3MzRaMIGUMQswCQYD
VQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsG
A1UECgwET2t0YTEUMBIGA1UECwwLU1NPUHJvdmlkZXIxFTATBgNVBAMMDGRldi0wMDQ4ODI3MzEc
MBoGCSqGSIb3DQEJARYNaW5mb0Bva3RhLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAIiKWQm8Vlycykc79TbHgbdQpuhwyZEcyhAZLNFRr5o3QAwwwRmnBWZ2eG3O3GqypQOw67iB
FKOH0yvQUM/fw+sfRjJoZlmFyQN2CFyJj8AOb4ptQC6QSs6TWCq3cMZ/ToQxIdUQi/Rmqro6skBa
0BCmBP4rfRoP2ygFyNR9OX60T6hD26um+M5+NRj1RN6rF+CBnt5WLhE7YW5nI6YtMO/Kn4VnOgU8
8oR9ePWFLtZrHOkwXSMzhxH+8j29huxjhLmIaRUjTYHdAwRkX7VRfkMQy93RsFxHu/1eltTSIdWD
i4I06j8qq4vu1cKcnCYew0xbMDHe0An1Cj0CwYB3IscCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEA
a6qoPOfXkKL1VrL4HkDsH8B8z337L4bBeAfoei0Je5e/6ifYnyS68S1uZlbWIb4XcdSStTti8JA4
tijqTuhOdfHfJ6pA7DStYhOzKtAGx1BWlqwkseurRoqnLg0zWN5Bx7y3RFWbKeYS3uCbF7DIgkRt
haAWFZghFMW8dBx905whPAh6H8AyT3T5XHu13CEmovksb3nPSu5BYeC8iS3Dlk6cb2opei0ZFVhx
KKgAjjk0SuLZhX7Ln8To/IwSbZmRCtR633BiJXaDBwATYm4deaDc2eWAhHW3/jFzSRzabvcYE/ip
pCGGNNxzIQaObmvz/DNc1d8tQjGgr8wkcnLObQ==
-----END CERTIFICATE-----"

 settings.idp_slo_service_url            = "http://localhost:3000/saml2/http-redirect/slo"
 settings.idp_slo_service_binding        = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect" # or :post, :redirect
 # settings.idp_cert_fingerprint           = OneLoginAppCertFingerPrint
 # settings.idp_cert_fingerprint_algorithm = "http://www.w3.org/2000/09/xmldsig#sha1"
 settings.name_identifier_format         = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"

 # Optional for most SAML IdPs
#  settings.authn_context = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
 # or as an array
 settings.authn_context = [
   "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport",
   "urn:oasis:names:tc:SAML:2.0:ac:classes:Password"
 ]

 # Optional bindings (defaults to Redirect for logout POST for ACS)
 settings.single_logout_service_binding      = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect" # or :post, :redirect
 settings.assertion_consumer_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" # or :post, :redirect

 settings
end

end