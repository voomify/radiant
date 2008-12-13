require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe 'Pages' do
  scenario :users
  
  before do
    Radiant::Config['defaults.page.parts'] = 'body'
    login :admin
  end
  
  it 'should be able to go to pages tab' do
    click_on :link => '/admin/pages'
  end
  
  it 'should be able to create the home page' do
    Page.delete_all # Need to create a homepage
    navigate_to '/admin/pages/new'
    response.should have_tag('#page_slug[value=?]','/')
    submit_form 'new_page', :continue => 'Save and Continue', :page => {:title => 'My Site', :slug => '/', :breadcrumb => 'My Site', :parts => [{:name => 'body', :content => 'Under Construction'}], :status_id => Status[:published].id}
    response.should_not have_tag('#error')
    response.should have_text(/Under\sConstruction/)
    response.should have_text(/My Site/)
    
    navigate_to '/'
    response.should have_text(/Under Construction/)
  end
end

describe "Pages as resource" do
  scenario :pages, :users
  
  it "should require authentication" do
    get "/admin/pages.xml"
    response.headers.keys.should include('WWW-Authenticate')
  end
  
  it 'should reject invalid creds' do
    get "/admin/pages.xml", nil, :authorization => encode_credentials(%w(admin badpassword))
    response.headers.keys.should include('WWW-Authenticate')
  end
  
  it 'should be obtainable by users' do
    get "/admin/pages.xml", nil, :authorization => encode_credentials(%w(admin password))
    response.body.should match(/xml/)
  end
  
  it 'should be obtainable as list' do
    get "/admin/pages.xml", nil, :authorization => encode_credentials(%w(admin password))
    response.body.should match(/pages/)
  end
  
  it "should include parts" do
    get "/admin/pages/#{page_id(:first)}.xml", nil, :authorization => encode_credentials(%w(admin password))
    response.body.should match(/parts type="array"/)
  end
end