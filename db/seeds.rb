# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Create some users

User.create(
	first_name: 'Jarred', 
	last_name: 'Trost', 
	email: 'jtrost@trilogyinteractive.com', 
	region: 'Houston',
	role: 'Administrator',
	title: 'IU-Comms',
	approved: true,
	receive_alerts: false,
	cell_phone: '123-456-7890',
	zip_code: '12345',
	local_number: '1111',
	council: 'IU',
	password: 'temp1234',
	password_confirmation: 'temp1234'
)

User.create(
	first_name: 'Tim', 
	last_name: 'Gutowski', 
	email: 'tgutowski@trilogyinteractive.com', 
	region: 'Chicago',
	role: 'Administrator',
	title: 'IU-Comms',
	approved: true,
	receive_alerts: false,
	cell_phone: '123-456-7890',
	zip_code: '60201',
	local_number: '1111',
	council: 'IU',
	password: 'temp1234',
	password_confirmation: 'temp1234'
)

User.create(
	first_name: 'Randy', 
	last_name: 'Stearns', 
	email: 'rstearns@trilogyinteractive.com', 
	region: 'Chicago',
	role: 'Administrator',
	title: 'IU-Comms',
	approved: true,
	receive_alerts: false,
	cell_phone: '123-456-7890',
	zip_code: '60201',
	local_number: '1111',
	council: 'IU',
	password: 'temp1234',
	password_confirmation: 'temp1234'
)

## Create some campaigns

Campaign.create(title: 'Never Quit', description: 'Don\'t ever quit!', status: 1)
Campaign.create(title: 'Convention 2017', description: 'This is for the 2017 convention', status: 1)
Campaign.create(title: 'Political', description: 'This is for political documents', status: 1)

# Create a basic template
Template.create!(
	title: 'Sector-specific',
	description: 'Integer elit massa, vulputate sit amet blandit ac, laoreet ut nisi. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.',
	height: 11,
	width: 8.5,
	pdf_markup: 'update me',
	form_markup: 'update me',
	numbered_image_file_name: 'numbered-ss.png',
	numbered_image_content_type: 'image/png',
	numbered_image_file_size: '426078',
	numbered_image_updated_at: DateTime.now,
	blank_image_file_name: 'blank-ss.png',
	blank_image_content_type: 'image/png',
	blank_image_file_size: '5876',
	blank_image_updated_at: DateTime.now,
	status: 1,
	campaign_id: Campaign.first.id,
	customizable_options: "<ol>
  <li>Headline</li>
  <li>Background image</li>
  <li>Quote and attribution</li>
  <li>Body text</li>
  <li>Affiliate logo (optional)</li>
  <li>NeverQuit logo</li>
</ol>"
)