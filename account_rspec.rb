require_relative 'account'
describe Account do

  before(:all) do
    @account = Account.new
  end

  it 'should new account have a balance of $0' do
    expect(@account.balance).to eql 0
  end

end
