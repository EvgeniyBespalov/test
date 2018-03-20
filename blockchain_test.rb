#есть транзакция и есть список адресов с наворованными деньгами
#нужно определить по этой транзакции  - имеет ли она отношение к наворованным деньгам


require_relative '/home/action/.rvm/gems/ruby-2.1.10/gems/blockchain-3.0.1/lib/blockchain/blockexplorer'

class AddressTepmlate
  attr_accessor :address, :tx_hash, :tx_time, :state
  
  def initialize address, tx_hash = nil, tx_time = nil, state = nil
    @address = address
    @tx_hash = tx_hash
    @tx_time = tx_time
    @state = state
  end
  
  def to_s
    "addr - " + @address.to_s
  end
end

class DataProvider
  attr_accessor :addresses_thief, :addresses_new, :blockexplorer
  
  def initialize blockexplorer
    @addresses_thief = []
    @blockexplorer = blockexplorer
  end
  
  def address_thief_insert address
    @addresses_new = []
    @addresses_new << AddressTepmlate.new(address, nil, nil, :new)
    
    address_recurce @addresses_new
    
    
    addresses_new.each {|k| @addresses_thief << k.address}
    
    
    @addresses_thief.each {|k| puts k}
    
  end
  
  def address_recurce addresses_new
    return if addresses_new.find_all{|n| n.state == :new}.length == 0 
    
    
    puts addresses_new.find_all{|n| n.state == :new}.length
    puts addresses_new.find{|n| n.state == :new}.to_s

    addresses_new.select { |a| a.state == :new } .each do |a|
      wallet = @blockexplorer.get_address_by_hash160(a.address)
      #wallet = @blockexplorer.get_address(a.address)
      #cycle by output transactions
      wallet.transactions.find_all{|tr| tr.inputs.find{|tri| tri.address == a.address}}.each do |t|
        trans = @blockexplorer.get_tx_by_hash t.hash
        trans.outputs.each do |o| 
          addresses_new << AddressTepmlate.new(o.address, t.hash, t.time, :newest) unless addresses_new.find{|an| an.address == o.address}
        end
      end
      addresses_new.find_all{|n| n.state == :new}.each {|n| n.state = :old}
      addresses_new.find_all{|n| n.state == :newest}.each {|n| n.state = :new}
      
      address_recurce addresses_new
    end
  end
  
end


class BlockchainOperation
  attr_reader:block
  attr_reader:data_provider
  #http://localhost:3000/ for work with localhost 
  #
  def initialize blockchain_path = "http://localhost:3000/"
    @block = Blockchain::BlockExplorer.new blockchain_path
    @data_provider = DataProvider.new @block
  end
  
  #returned hash include transactions with thief address
  def transaction_verification tx_hash
  
    trans = [tx_hash]
    
    result = Hash.new       
    
    trans.each do |t|
      trans = @block.get_tx_by_hash tx_hash   
      
      result = result.merge trans_addr_verify(@data_provider, trans.hash, trans.inputs)
      result = result.merge trans_addr_verify(@data_provider, trans.hash, trans.outputs)
      
      
    end
    
    result 
  end
  
  
  
  private
  
  
  
  
  def transaction_get address
    #wallet = Blockchain::BlockExplorer.new.get_address_by_hash160(address)  
    address  
  end
  
  def trans_addr_verify data_provider, trans, trans_addrs
    
    result = Hash.new 
    
    trans_addrs.each do |a|
      if data_provider.addresses_thief.find {|b| b == a.address}
        if result[trans] == nil    
          result[trans] = [a.address]
        else
          result[trans] << a.address
        end
      end      
    end
    
    result
  end

end


oper = BlockchainOperation.new "http://localhost:8332/"
#oper = BlockchainOperation.new "https://blockchain.info/"
#oper.data_provider.address_thief_insert "14UEUL1DhGGKDB15g8QdSwyLFtJBniaBbq"
oper.data_provider.address_thief_insert "1LiZnr8VBpJAetZJPkfae4cEVAZoxMgggb"
puts oper.transaction_verification "4ff162eceb4392a38f269aab1ee1df567ae06875042b3ab6b53bd334c2e9e888"



require_relative '/home/action/.rvm/gems/ruby-2.1.10/gems/blockchain-3.0.1/lib/blockchain/blockexplorer'
Blockchain::BlockExplorer.new.get_tx_by_hash "4ff162eceb4392a38f269aab1ee1df567ae06875042b3ab6b53bd334c2e9e888"


#wallet = Blockchain::BlockExplorer.new.get_address_by_hash160#("12KpaMwvTfvCstg9VmTzrApCuwmhsW9RqE") 
#
#wallet.transactions.each do |t|
#puts t.hash
#end

=begin
#<Blockchain::Transaction:0x0055dd5d9d9cf8 
@double_spend=false, 
@block_height=463319, 
@time=1493040981, 
@relayed_by="46.109.94.117", 
@hash="4ff162eceb4392a38f269aab1ee1df567ae06875042b3ab6b53bd334c2e9e888", 
@tx_index=243978161, 
@version=1, 
@size=226, 
@inputs=[#<Blockchain::Input:0x0055dd5d9d9b40 
@n=1, 
@value=21000000, 
@address="14UEUL1DhGGKDB15g8QdSwyLFtJBniaBbq", 
@tx_index=243899203, 
@type=0, 
@script="76a914260eda7ddd859dc7458aab87883e00499e092d7288ac", 
@script_sig="483045022100d6c074fd3c71660957f42149b13f8d40ea360a9d9ae8935b4d934d5be693401e0220275a4e13e4048cfa4434dea2104e1fd6b0d77092d715c7d594240e6aa3909d930121035205ba250ae9cc3242c685c7b5137a84755bd03a93af8eb848efba26b8fc57da", 
@sequence=4294967295>], 
@outputs=[#<Blockchain::Output:0x0055dd5d9d9960 
@n=0, 
@value=17915016, 
@address="12KpaMwvTfvCstg9VmTzrApCuwmhsW9RqE", 
@tx_index=243978161, 
@script="76a9140e8753ad86c017f5a32d5db3c9c0de8e0c739c2188ac", 
@spent=true>, 
#<Blockchain::Output:0x0055dd5d9d9848 
@n=1, 
@value=3034984, 
@address="1HfxCeg8dTFnqJr335uJsY96Pvyy2QyaCe", 
@tx_index=243978161, 
@script="76a914b6dfe6003f309e03f2c9bd8ef82cca31e821c5c988ac", 
@spent=true>]> 
=end
