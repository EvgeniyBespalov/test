#есть транзакция и есть список адресов с наворованными деньгами
#нужно определить по этой транзакции  - имеет ли она отношение к наворованным деньгам


require_relative '/home/action/.rvm/gems/ruby-2.1.10/gems/blockchain-3.0.1/lib/blockchain/blockexplorer'

class BlockchainOperation
  attr_reader:block
  
  def initialize
    @block = Blockchain::BlockExplorer.new
  end
  
  #returned hash include transactions with bad address
  def valid_transaction tx_hash
  
    trans = [tx_hash]
    
    result = Hash.new       
    
    trans.each do |t|
      trans = Blockchain::BlockExplorer.new.get_tx_by_hash tx_hash   
      
      result = result.merge trans_addr_verify(trans.hash, trans.inputs)
      result = result.merge trans_addr_verify(trans.hash, trans.outputs)
      
    end
      
    result
  end

  private
  
  def addresses_bad_get
    #fictive address array
    addresses = ['14UEUL1DhGGKDB15g8QdSwyLFtJBniaBbq']
  end
  
  def trans_addr_verify trans, trans_addrs
    
    result = Hash.new
    addresses_bad = addresses_bad_get 
    
    trans_addrs.each do |a|
      if addresses_bad.find {|b| b == a.address}
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

oper = BlockchainOperation.new
puts oper.valid_transaction "4ff162eceb4392a38f269aab1ee1df567ae06875042b3ab6b53bd334c2e9e888"





#wallet = Blockchain::BlockExplorer.new.get_address_by_hash160#("12KpaMwvTfvCstg9VmTzrApCuwmhsW9RqE") 
#
#wallet.transactions.each do |t|
#puts t.hash
#end
