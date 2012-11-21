require 'rexml/document'
require 'builder'
require 'nokogiri'

module MtnMoney
  #include HTTParty
  module Public


  def create_deposit_xml(username,password,amount,account,provider_code,narrative,method )


    builder = Nokogiri::XML::Builder.new do |xml|
        xml.AutoCreate {
          xml.Request {
            xml.APIUsername  username
            xml.APIPassword password
            xml.Account account
            xml.Amount amount
            xml.NonBlocking "TRUE"
            xml.Method  method
            xml.AccountProviderCode provider_code
            xml.Narrative narrative

          }
        }

    end
    return builder.to_xml

  end

def check_transaction_status(username,password,transaction_reference,transaction_type)

 builder = Nokogiri::XML::Builder.new do |xml|
        xml.AutoCreate {
          xml.Request {
            xml.APIUsername  username
            xml.APIPassword password
            xml.DepositTransactionType transaction_type
            xml.TransactionReference transaction_reference
            xml.Method  "actransactioncheckstatus"

          }
        }

    end
    return builder.to_xml


end

def check_balance(username,password)
  builder = Nokogiri::XML::Builder.new do |xml|
    xml.root {
      xml.AutoCreate {
        xml.Request {
          xml.APIUsername  username
          xml.APIPassword password
          xml.Method  "acacctbalance"

        }
      }
    }
  end
  return builder.to_xml

end




  def post_request(xml,url)
    require 'net/https'
    require 'net/http'

    url = URI.parse(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url.path)

    request.body =xml
    request["Content-Type"]="text/xml"
    request["ontent-transfer-encoding"]="text"
    response = http.start {|http| http.request(request) }

    doc = Nokogiri::XML(response.body)
    hash_to_ret=doc.search('//Response').map{ |e| Hash.from_xml(e.to_xml)['Response'] }
    return  hash_to_ret
  end




  end
  end



