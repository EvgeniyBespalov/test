#есть транзакция и есть список адресов с наворованными деньгами
#нужно определить по этой транзакции  - имеет ли она отношение к наворованным деньгам


require_relative 'blockexplorer'


class DataProvider
  attr_reader:addresses_bad
  
  def initialize
    @addresses_bad = []
  end
  
  def address_bad_insert address
    @addresses_bad << address
  end
  
  
end


class BlockchainOperation
  attr_reader:block
  attr_reader:data_provider
  #http://localhost:3000/ for work with localhost 
  #
  def initialize blockchain_path = "http://localhost:3000/"
    @block = Blockchain::BlockExplorer.new blockchain_path
    @data_provider = DataProvider.new
  end
  
  #returned hash include transactions with bad address
  def valid_transaction tx_hash
  
    trans = [tx_hash]
    
    result = Hash.new       
    
    trans.each do |t|
      trans = Blockchain::BlockExplorer.new.get_tx_by_hash tx_hash   
      
      result = result.merge trans_addr_verify(@data_provider, trans.hash, trans.inputs)
      result = result.merge trans_addr_verify(@data_provider, trans.hash, trans.outputs)
      
    end
      
    result
  end
  
  private
  
  def trans_addr_verify data_provider, trans, trans_addrs
    
    result = Hash.new 
    
    trans_addrs.each do |a|
      if data_provider.addresses_bad.find {|b| b == a.address}
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



oper = BlockchainOperation.new "https://blockchain.info/"
oper.data_provider.address_bad_insert "14UEUL1DhGGKDB15g8QdSwyLFtJBniaBbq"
puts oper.valid_transaction "4ff162eceb4392a38f269aab1ee1df567ae06875042b3ab6b53bd334c2e9e888"



#wallet = Blockchain::BlockExplorer.new.get_address_by_hash160#("12KpaMwvTfvCstg9VmTzrApCuwmhsW9RqE") 
#
#wallet.transactions.each do |t|
#puts t.hash
#end

