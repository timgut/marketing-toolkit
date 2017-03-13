# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Create some users

# User.create(
# 	first_name: 'Kevin', 
# 	last_name: 'Hanes', 
# 	email: 'nothing@trilogyinteractive.com', 
# 	affiliate_id: 6,
# 	role: 'Vetter',
# 	department: 'IU-Communications',
# 	approved: true,
# 	receive_alerts: false,
# 	cell_phone: '123-456-7890',
# 	zip_code: '12345',
# 	local_number: '1111',
# 	council: 'IU',
# 	password: 'temp1234',
# 	password_confirmation: 'temp1234'
# )

# User.create(
#   first_name: 'Kevin', 
#   last_name: 'Brown', 
#   email: 'nothing-1@trilogyinteractive.com', 
#   affiliate_id: 6,
#   role: 'Vetter',
#   department: 'IU-Communications',
#   approved: true,
#   receive_alerts: false,
#   cell_phone: '123-456-7890',
#   zip_code: '12345',
#   local_number: '1111',
#   council: 'IU',
#   password: 'temp1234',
#   password_confirmation: 'temp1234'
# )

# User.create(
#   first_name: 'Dave', 
#   last_name: 'Kreisman', 
#   email: 'nothing-2@trilogyinteractive.com', 
#   affiliate_id: 6,
#   role: 'Vetter',
#   department: 'IU-Communications',
#   approved: true,
#   receive_alerts: false,
#   cell_phone: '123-456-7890',
#   zip_code: '12345',
#   local_number: '1111',
#   council: 'IU',
#   password: 'temp1234',
#   password_confirmation: 'temp1234'
# )

User.create(
  first_name: 'Namita', 
  last_name: 'Waghray', 
  email: 'nothing-3@trilogyinteractive.com', 
  affiliate_id: 6,
  role: 'Administrator',
  department: 'IU-Communications',
  approved: true,
  receive_alerts: false,
  cell_phone: '123-456-7890',
  zip_code: '12345',
  local_number: '1111',
  council: 'IU',
  password: 'temp1234',
  password_confirmation: 'temp1234'
)

users = [ 
  {name: 'Michelle Sforza', email: 'msforza@testg.org' },
  {name: 'Megan Eierman', email: 'meierman@testg.org' },
  {name: 'Joe Guzynshki', email: 'jguzynski@testg.org' },
  {name: 'Brian Weeks', email: 'bweeks@testg.org' },
  {name: 'Doug Brunett', email: 'dburnett@testg.org' },
  {name: 'Roni Beavins ', email: 'rbeavin@testg.org' },
  {name: 'Dalia Thornton', email: 'dthornton@testg.org' },
  {name: 'Stacey Bashara', email: 'sbashara@testg.org' },
]

users.each do |user|

  User.create(
    first_name: user[:name].split(' ')[0], 
    last_name: user[:name].split(' ')[1], 
    email: user[:email],
    affiliate_id: 6,
    role: 'Administrator',
    department: 'IU-Communications',
    approved: true,
    receive_alerts: false,
    cell_phone: '123-456-7890',
    zip_code: '12345',
    local_number: '1111',
    council: 'IU',
    password: 'temp1234',
    password_confirmation: 'temp1234'
  )

end

## Create some campaigns

# Campaign.create(title: 'Internal Organizing', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit', status: 1)
# Campaign.create(title: 'Contract', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit', status: 1)
# Campaign.create(title: 'Affiliation', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit', status: 1)
# Campaign.create(title: 'Legislative', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit', status: 1)
# Campaign.create(title: 'Political/Electoral', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit', status: 1)

## Create some categories

# Category.create(title: "Flyer")
# Category.create(title: "Poster")
# Category.create(title: "Newsletter")
# Category.create(title: "Mail Piece")


##Create a basic template
# Template.create!(
# 	title: 'Sector-specific',
# 	description: 'Integer elit massa, vulputate sit amet blandit ac, laoreet ut nisi. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.',
# 	height: 11,
# 	width: 8.5,
# 	pdf_markup: 'update me',
# 	form_markup: 'update me',
# 	numbered_image_file_name: 'numbered-ss.png',
# 	numbered_image_content_type: 'image/png',
# 	numbered_image_file_size: '426078',
# 	numbered_image_updated_at: DateTime.now,
# 	blank_image_file_name: 'blank-ss.png',
# 	blank_image_content_type: 'image/png',
# 	blank_image_file_size: '5876',
# 	blank_image_updated_at: DateTime.now,
# 	status: 1,
# 	campaign_id: Campaign.first.id,
# 	category_id: Category.first.id,
# 	customizable_options: "<ol>
#   <li>Headline</li>
#   <li>Background image</li>
#   <li>Quote and attribution</li>
#   <li>Body text</li>
#   <li>Affiliate logo (optional)</li>
#   <li>NeverQuit logo</li>
# </ol>"
# )


## Create the Affiliates

## seed_affiliates.rb

STATE = {
  'AL' => 'Alabama',
  'AK' => 'Alaska',
  'AS' => 'America Samoa',
  'AZ' => 'Arizona',
  'AR' => 'Arkansas',
  'CA' => 'California',
  'CO' => 'Colorado',
  'CT' => 'Connecticut',
  'DE' => 'Delaware',
  'DC' => 'District of Columbia',
  'FM' => 'Federated States Of Micronesia',
  'FL' => 'Florida',
  'GA' => 'Georgia',
  'GU' => 'Guam',
  'HI' => 'Hawaii',
  'ID' => 'Idaho',
  'IL' => 'Illinois',
  'IN' => 'Indiana',
  'IA' => 'Iowa',
  'KS' => 'Kansas',
  'KY' => 'Kentucky',
  'LA' => 'Louisiana',
  'ME' => 'Maine',
  'MH' => 'Marshall Islands',
  'MD' => 'Maryland',
  'MA' => 'Massachusetts',
  'MI' => 'Michigan',
  'MN' => 'Minnesota',
  'MS' => 'Mississippi',
  'MO' => 'Missouri',
  'MT' => 'Montana',
  'NE' => 'Nebraska',
  'NV' => 'Nevada',
  'NH' => 'New Hampshire',
  'NJ' => 'New Jersey',
  'NM' => 'New Mexico',
  'NY' => 'New York',
  'NC' => 'North Carolina',
  'ND' => 'North Dakota',
  'OH' => 'Ohio',
  'OK' => 'Oklahoma',
  'OR' => 'Oregon',
  'PW' => 'Palau',
  'PA' => 'Pennsylvania',
  'PR' => 'Puerto Rico',
  'RI' => 'Rhode Island',
  'SC' => 'South Carolina',
  'SD' => 'South Dakota',
  'TN' => 'Tennessee',
  'TX' => 'Texas',
  'UT' => 'Utah',
  'VT' => 'Vermont',
  'VI' => 'Virgin Island',
  'VA' => 'Virginia',
  'WA' => 'Washington',
  'WV' => 'West Virginia',
  'WI' => 'Wisconsin',
  'WY' => 'Wyoming'
}

REGION = {
  'Alabama' => 'Southern',
  'Alaska' => 'Western',
  'Arizona' => 'Western',
  'Arkansas' => 'Southern',
  'California' => 'Western',
  'Colorado' => 'Western',
  'Connecticut' => 'Eastern',
  'Delaware' => 'Eastern',
  'District of Columbia' => 'Eastern',
  'Florida' => 'Southern',
  'Georgia' => 'Southern',
  'Hawaii' => 'Western',
  'Idaho' => 'Western',
  'Illinois' => 'Central',
  'IN' => 'Central',
  'Iowa' => 'Central',
  'Kansas' => 'Central',
  'Kentucky' => 'Central',
  'Louisiana' => 'Southern',
  'Maine' => 'Eastern',
  'Maryland' => 'Eastern',
  'Massachusetts' => 'Eastern',
  'Michigan' => 'Central',
  'Minnesota' => 'Central',
  'Mississippi' => 'Southern',
  'Missouri' => 'Central',
  'Montana' => 'Western',
  'Nebraska' => 'Central',
  'Nevada' => 'Western',
  'New Hampshire' => 'Eastern',
  'New Jersey' => 'Eastern',
  'New Mexico' => 'Western',
  'New York' => 'Eastern',
  'North Carolina' => 'Southern',
  'North Dakota' => 'Central',
  'Ohio' => 'Central',
  'Oklahoma' => 'Southern',
  'Oregon' => 'Western',
  'Pennsylvania' => 'Eastern',
  'Puerto Rico' => 'Eastern',
  'Rhode Island' => 'Eastern',
  'South Carolina' => 'Southern',
  'South Dakota' => 'Central',
  'Tennessee' => 'Southern',
  'Texas' => 'Southern',
  'Utah' => 'Western',
  'Vermont' => 'Eastern',
  'Virginia' => 'Southern',
  'Washington' => 'Western',
  'West Virginia' => 'Central',
  'Wisconsin' => 'Central',
  'Wyoming' => 'Western'
 }

affiliates = [
    {:title => "Anchorage Municipal Employees", :state => "AK", :slug => "L16"},
    {:title => "Alaska State Employees Association", :state => "AK", :slug => "L52"},
    {:title => "PSEA Local 803", :state => "AK", :slug => "L803"},
    {:title => "Alaska Retirees Chapter 52", :state => "AK", :slug => "L52"},
    {:title => "Arkansas State Council", :state => "AR", :slug => "C38"},
    {:title => "Phoenix Arizona City Employees", :state => "AZ", :slug => "L2384"},
    {:title => "Phoenix Clerical Pre-Professional", :state => "AZ", :slug => "L2960"},
    {:title => "Peoria City; Gila &amp; Maricopa", :state => "AZ", :slug => "L3282"},
    {:title => "Tucson-Pima County Area Public Employees", :state => "AZ", :slug => "L449"},
    {:title => "Arizona Retirees Chapter 97", :state => "AZ", :slug => "RC97"},
    {:title => "California District Council 36", :state => "CA", :slug => "C36"},
    {:title => "California District Council 57", :state => "CA", :slug => "C57"},
    {:title => "MAPA Local 1001", :state => "CA", :slug => "L1001"},
    {:title => "Metro Water District Employees", :state => "CA", :slug => "L1902"},
    {:title => "Union of American Physicians &amp; Dentists", :state => "CA", :slug => "L206"},
    {:title => "University of California Employees", :state => "CA", :slug => "L3299"},
    {:title => "UDWA Local 3930", :state => "CA", :slug => "L3930"},
    {:title => "CUCalifornia United Homecare Workers", :state => "CA", :slug => "L4034"},
    {:title => "UEMSW Emergency Medical Workers", :state => "CA", :slug => "L4911"},
    {:title => "UNAC/UHCP 1199U Retirees", :state => "CA", :slug => "RC1199"},
    {:title => "California Retiree Chapter 36", :state => "CA", :slug => "RC36"},
    {:title => "California Retiree Chapter 57", :state => "CA", :slug => "RC57"},
    {:title => "UAPD Retiree Sub-Chapter 206", :state => "CA", :slug => "RSC206"},
    {:title => "Colorado Union of Public Employees", :state => "CO", :slug => "C76"},
    {:title => "Colorado Wins State Employees", :state => "CO", :slug => "L1876"},
    {:title => "Colorado Public Employees Retiree Chapter 76", :state => "CO", :slug => "RC76"},
    {:title => "Connecticut Council 4", :state => "CT", :slug => "C4"},
    {:title => "Connecticut Retired Police Officers Association", :state => "CT", :slug => "RC15"},
    {:title => "Connecticut Public Employees Retiree Chapter 4", :state => "CT", :slug => "RC4"},
    {:title => "Washington D.C. Council 20", :state => "DC", :slug => "C20"},
    {:title => "Capital Area Council of Federal Employees", :state => "DC", :slug => "C26"},
    {:title => "PCT Bookkeeping", :state => "DC", :slug => "C300"},
    {:title => "Retirees at Large", :state => "DC", :slug => "RC300"},
    {:title => "Retirees AFSCME Pensioners", :state => "DC", :slug => "RC9980"},
    {:title => "UNCHRT Retirees", :state => "DC", :slug => "RC9990"},
    {:title => "Delaware Public Employees Council 81", :state => "DE", :slug => "C81"},
    {:title => "AFSCME Delaware Retirees", :state => "DE", :slug => "RC81"},
    {:title => "Florida Public Employees Council 79", :state => "FL", :slug => "C79"},
    {:title => "City of Miami Association of Retired Employees", :state => "FL", :slug => "RC11"},
    {:title => "Florida Public Retirees", :state => "FL", :slug => "RC79"},
    {:title => "Greater Atlanta Area Employees", :state => "GA", :slug => "L1644"},
    {:title => "Fulton County Employees", :state => "GA", :slug => "L3"},
    {:title => "HawaiiI Government Employees Association", :state => "HI", :slug => "L152"},
    {:title => "United Public Workers", :state => "HI", :slug => "L646"},
    {:title => "AFSCME Local 928", :state => "HI", :slug => "L928"},
    {:title => "Hawaii AFSCME Retirees Chapter 152", :state => "HI", :slug => "RC152"},
    {:title => "Hawaii UPW AFSCME Retirees Chapter 646", :state => "HI", :slug => "RC646"},
    {:title => "Iowa Public Employees Council 61", :state => "IA", :slug => "C61"},
    {:title => "Iowa Retiree Chapter 61", :state => "IA", :slug => "RC61"},
    {:title => "Illinois Pubic Employees Council 31", :state => "IL", :slug => "C31"},
    {:title => "Illinois Public Employees Retirees", :state => "IL", :slug => "RC31"},
    {:title => "Indiana-Kentucky Council 962", :state => "IN", :slug => "C962"},
    {:title => "Indiana Retirees", :state => "IN", :slug => "RC9962"},
    {:title => "KOSE", :state => "KS", :slug => "L300"},
    {:title => "Indiana-Kentucky Council 962", :state => "KY", :slug => "C962"},
    {:title => "Missouri &amp; Kansas Council 72", :state => "KY", :slug => "C72"},
    {:title => "Louisiana Public Employees Council 17", :state => "LA", :slug => "C17"},
    {:title => "AFSCME Council 93", :state => "MA", :slug => "C93"},
    {:title => "Union of Social Workers", :state => "MA", :slug => "L1798"},
    {:title => "Harvard Clerical &amp; Tech Workers", :state => "MA", :slug => "L3650"},
    {:title => "SHARE Local 3900", :state => "MA", :slug => "L3900"},
    {:title => "SHARE Local 4000", :state => "MA", :slug => "L4000"},
    {:title => "Massachusetts Public Employees Retiree Chapter 93", :state => "MA", :slug => "RC93"},
    {:title => "Maryland Council 3", :state => "MD", :slug => "C3"},
    {:title => "Maryland Public Employees Council 67", :state => "MD", :slug => "C67"},
    {:title => "Prince George's County Public Service Employees", :state => "MD", :slug => "L2250"},
    {:title => "Maryland Public Employees Retiree Chapter 1", :state => "MD", :slug => "RC1"},
    {:title => "ACE/AFSCME Retirees Sub-Chapter 2250", :state => "MD", :slug => "RSC2250"},
    {:title => "AFSCME Council 93", :state => "ME", :slug => "C93"},
    {:title => "Maine Public Employees Retiree Chapter 93", :state => "ME", :slug => "RC93"},
    {:title => "Michigan Council 25", :state => "MI", :slug => "C25"},
    {:title => "Michigan State Employees Association", :state => "MI", :slug => "L5"},
    {:title => "Michigan Organizing Chapter 9925", :state => "MI", :slug => "RC9925"},
    {:title => "Minnesota Council Number 5", :state => "MN", :slug => "C5"},
    {:title => "Minnesota and Dakotas Council 65", :state => "MN", :slug => "C65"},
    {:title => "Minnesota Retirees United", :state => "MN", :slug => "RC5"},
    {:title => "Minnesota Retirees Chapter 65", :state => "MN", :slug => "RC65"},
    {:title => "Missouri &amp; Kansas Council 72", :state => "MO", :slug => "C72"},
    {:title => "Kansas City Public Employees", :state => "MO", :slug => "L500"},
    {:title => "Missouri Retirees Chapter", :state => "MO", :slug => "RC9972"},
    {:title => "Montana State Council 9", :state => "MT", :slug => "C9"},
    {:title => "Montana Retirees Public Employees Retiree Chapter 9", :state => "MT", :slug => "RC9"},
    {:title => "Duke University Employees", :state => "NC", :slug => "L77"},
    {:title => "North Carolina AFSCME Retirees", :state => "NC", :slug => "RSC165"},
    {:title => "Minnesota and Dakotas Council 65", :state => "ND", :slug => "C65"},
    {:title => "Lancaster County Courthouse Employees", :state => "NE", :slug => "L2468"},
    {:title => "Nebraska Public Employees", :state => "NE", :slug => "L251"},
    {:title => "Nebraska Association of Public Employees", :state => "NE", :slug => "L61"},
    {:title => "NAPE Retiree Chapter 161", :state => "NE", :slug => "RC161"},
    {:title => "AFSCME Council 93", :state => "NH", :slug => "C93"},
    {:title => "New Hampshire Public Employees Retiree Chapter 93", :state => "NH", :slug => "RC93"},
    {:title => "New Jersey Public Employees Council 1", :state => "NJ", :slug => "C1"},
    {:title => "Northern New Jersey Council 52", :state => "NJ", :slug => "C52"},
    {:title => "Southern New Jersey District Council 71", :state => "NJ", :slug => "C71"},
    {:title => "Central New Jersey District Council 73", :state => "NJ", :slug => "C73"},
    {:title => "New Jersey Sub-Chapter 1 Retirees", :state => "NJ", :slug => "RSC9901"},
    {:title => "1199J Retired Members Division", :state => "NJ", :slug => "RC1199"},
    {:title => "New Mexico Public Employees Council 18", :state => "NM", :slug => "C18"},
    {:title => "New Mexico Public Employees Retiree Chapter 18", :state => "NM", :slug => "RC18"},
    {:title => "NUHHCE Local 1199", :state => "NT", :slug => "L1199"},
    {:title => "AFSCME Local 4041", :state => "NV", :slug => "L4041"},
    {:title => "SNEA/AFSCME Retirees Chapter 4041", :state => "NV", :slug => "RC4041"},
    {:title => "District Council 1707", :state => "NY", :slug => "C1707"},
    {:title => "Buffalo District Council 35", :state => "NY", :slug => "C35"},
    {:title => "New York City District Council 37", :state => "NY", :slug => "C37"},
    {:title => "New York County Municipal Employees", :state => "NY", :slug => "C66"},
    {:title => "New York State Law Enforcement Officers Union", :state => "NY", :slug => "C82"},
    {:title => "Civil Service Employees Association (CSEA)", :state => "NY", :slug => "L1000"},
    {:title => "Retiree Division CSEA Chapter 1000", :state => "NY", :slug => "RC1000"},
    {:title => "District Council 1707 Retirees", :state => "NY", :slug => "RC1707"},
    {:title => "Buffalo New York Retirees Chapter 35", :state => "NY", :slug => "RC35"},
    {:title => "Retirees Association of NYC District Counicl 37", :state => "NY", :slug => "RC37"},
    {:title => "New York State Law Enforcement Retirees", :state => "NY", :slug => "RC82"},
    {:title => "Ohio Council 8", :state => "OH", :slug => "C8"},
    {:title => "Ohio Civil Service Employees Association", :state => "OH", :slug => "L11"},
    {:title => "Ohio Association of Public Service Employees Local 4", :state => "OH", :slug => "L4"},
    {:title => "Ohio AFSCME Retiree Chapter", :state => "OH", :slug => "RC1184"},
    {:title => "Enid Oklahoma City Employees", :state => "OK", :slug => "L1136"},
    {:title => "Tulsa Public Employees Union", :state => "OK", :slug => "L1180"},
    {:title => "Local 2406", :state => "OK", :slug => "L2406"},
    {:title => "Muskogee Oklahoma Municipal Employees", :state => "OK", :slug => "L2465"},
    {:title => "Norman Oklahoma City Employees", :state => "OK", :slug => "L2875"},
    {:title => "Oregon AFSCME Council 75", :state => "OR", :slug => "C75"},
    {:title => "Oregon Public Retirees", :state => "OR", :slug => "RC75"},
    {:title => "Pennsylvania Public Employees Council 13", :state => "PA", :slug => "C13"},
    {:title => "District Council 33", :state => "PA", :slug => "C33"},
    {:title => "Admin Professional &amp; Tech Employees Council 47", :state => "PA", :slug => "C47"},
    {:title => "Southwestern PA Public Employees District Council 83", :state => "PA", :slug => "C83"},
    {:title => "Western PA Public Employees District Council 84", :state => "PA", :slug => "C84"},
    {:title => "Northwestern PA Public Employees District Council 85", :state => "PA", :slug => "C85"},
    {:title => "North Central PA Public Employees District Council 86", :state => "PA", :slug => "C86"},
    {:title => "Northeastern PA Public Employees District Council 87", :state => "PA", :slug => "C87"},
    {:title => "Southeastern PA Public Employees District Council 88", :state => "PA", :slug => "C88"},
    {:title => "Southern PA Public Employees District Council 89", :state => "PA", :slug => "C89"},
    {:title => "Dauphin County PA Public Employees District Council 90", :state => "PA", :slug => "C90"},
    {:title => "1199C Retired Members Division", :state => "PA", :slug => "RC1199"},
    {:title => "Retired Public Employees PA Chapter 13", :state => "PA", :slug => "RC13"},
    {:title => "Golden Age Club", :state => "PA", :slug => "RC2"},
    {:title => "Philadelphia Retirees Chapter 47", :state => "PA", :slug => "RC47"},
    {:title => "SPUPR/AFSCME Council 95", :state => "PR", :slug => "C95"},
    {:title => "United Public Workers of Puerto Rico", :state => "PR", :slug => "RC95"},
    {:title => "Rhode Island Council 94", :state => "RI", :slug => "C94"},
    {:title => "AFSCME Rhode Island Retirees", :state => "RI", :slug => "RC94"},
    {:title => "Minnesota and Dakotas Council 65", :state => "SD", :slug => "C65"},
    {:title => "Memphis Public Employees Union", :state => "TN", :slug => "L1733"},
    {:title => "Brushy Mt State Prison Employees", :state => "TN", :slug => "L2173"},
    {:title => "AFSCME Texas Correctional Employees Council 7", :state => "TX", :slug => "C7"},
    {:title => "HOPE", :state => "TX", :slug => "L123"},
    {:title => "AFSCME Local 1550", :state => "TX", :slug => "L1550"},
    {:title => "Central Texas Public Employees Local 1624", :state => "TX", :slug => "L1624"},
    {:title => "El Paso Texas Public Employees", :state => "TX", :slug => "L59"},
    {:title => "Texas Public Retirees Chapter 12", :state => "TX", :slug => "RC12"},
    {:title => "Houston Public Employees Retiree Chapter 1550", :state => "TX", :slug => "RC1550"},
    {:title => "Utah Public Employees", :state => "UT", :slug => "L1004"},
    {:title => "Virginia State Employees Council 27", :state => "VA", :slug => "C27"},
    {:title => "Virginia Public Employees Union Local 3001", :state => "VA", :slug => "L3001"},
    {:title => "AFSCME Council 93", :state => "VT", :slug => "C93"},
    {:title => "Vermont Public Employees Retiree Chapter 93", :state => "VT", :slug => "RC93"},
    {:title => "Washington State County &amp; City Employees Council 2", :state => "WA", :slug => "C2"},
    {:title => "Washington Federation of State Employees Council 28", :state => "WA", :slug => "C28"},
    {:title => "Retired Public Employees Council", :state => "WA", :slug => "RC10"},
    {:title => "Wisconsin Council 32", :state => "WI", :slug => "C32"},
    {:title => "Wisconsin Retired Public Employees", :state => "WI", :slug => "RC32"},
    {:title => "AFSCME West Virginia Council 77", :state => "WV", :slug => "C77"},
    {:title => "West Virginia Public Employees Retirees Chapter 77", :state => "WV", :slug => "RC77"}
]

# Affiliate.create!(title: 'International Union', slug: "IU", state: 'N/A', region: 'N/A')

# affiliates.each do |aff|
# 	aff[:state] = STATE[aff[:state]]
# 	aff[:region] = REGION[aff[:state]]
# 	puts 
# 	@aff = Affiliate.new(aff)
# 	if @aff.save
# 		puts "#{@aff.title} created."
# 	else
# 		puts "There was a problem: #{@aff.inspect}."
# 	end
# end

# Affiliate.create!(title: 'Unknown', slug: "unknown", state: 'N/A', region: 'N/A')

