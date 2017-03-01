class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :flyers
  has_and_belongs_to_many :images

  scope :approved, -> { where(approved: 1) }
  scope :unapproved, -> { where(approved: 0, rejected: 0) }
  scope :rejected, -> { where(rejected: 1) }

  scope :approvers, -> { where(role: ['Administrator','Vetter']) }

  after_create :send_admin_emails

  ROLES = ['User', 'Local President', 'Vetter', 'Administrator']

  AFFILIATES = {
    "International Union" => "IU",
    "AK - Anchorage Municipal Employees" => "L16",
    "AK - Alaska State Employees Association" => "L52",
    "AK - PSEA Local 803" => "L803",
    "AK - Alaska Retirees Chapter 52" => "L52",
    "AR - Arkansas State Council" => "C38",
    "AZ - Phoenix Arizona City Employees" => "L2384",
    "AZ - Phoenix Clerical Pre-Professional" => "L2960",
    "AZ - Peoria City; Gila &amp; Maricopa" => "L3282",
    "AZ - Tucson-Pima County Area Public Employees" => "L449",
    "AZ - Arizona Retirees Chapter 97" => "RC97",
    "CA - California District Council 36" => "C36",
    "CA - California District Council 57" => "C57",
    "CA - MAPA Local 1001" => "L1001",
    "CA - Metro Water District Employees" => "L1902",
    "CA - Union of American Physicians &amp; Dentists" => "L206",
    "CA - University of California Employees" => "L3299",
    "CA - UDWA Local 3930" => "L3930",
    "CA - CUCalifornia United Homecare Workers" => "L4034",
    "CA - UEMSW Emergency Medical Workers" => "L4911",
    "CA - UNAC/UHCP 1199U Retirees" => "RC1199",
    "CA - California Retiree Chapter 36" => "RC36",
    "CA - California Retiree Chapter 57" => "RC57",
    "CA - UAPD Retiree Sub-Chapter 206" => "RSC206",
    "CO - Colorado Union of Public Employees" => "C76",
    "CO - Colorado Wins State Employees" => "L1876",
    "CO - Colorado Public Employees Retiree Chapter 76" => "RC76",
    "CT - Connecticut Council 4" => "C4",
    "CT - Connecticut Retired Police Officers Association" => "RC15",
    "CT - Connecticut Public Employees Retiree Chapter 4" => "RC4",
    "DC - Washington D.C. Council 20" => "C20",
    "DC - Capital Area Council of Federal Employees" => "C26",
    "DC - PCT Bookkeeping" => "C300",
    "DC - Retirees at Large" => "RC300",
    "DC - Retirees AFSCME Pensioners" => "RC9980",
    "DC - UNCHRT Retirees" => "RC9990",
    "DE - Delaware Public Employees Council 81" => "C81",
    "DE - AFSCME Delaware Retirees" => "RC81",
    "FL - Florida Public Employees Council 79" => "C79",
    "FL - City of Miami Association of Retired Employees" => "RC11",
    "FL - Florida Public Retirees" => "RC79",
    "GA - Greater Atlanta Area Employees" => "L1644",
    "GA - Fulton County Employees" => "L3",
    "HI - HawaiiI Government Employees Association" => "L152",
    "HI - United Public Workers" => "L646",
    "HI - AFSCME Local 928" => "L928",
    "HI - Hawaii AFSCME Retirees Chapter 152" => "RC152",
    "HI - Hawaii UPW AFSCME Retirees Chapter 646" => "RC646",
    "IA - Iowa Public Employees Council 61" => "C61",
    "IA - Iowa Retiree Chapter 61" => "RC61",
    "IL - Illinois Pubic Employees Council 31" => "C31",
    "IL - Illinois Public Employees Retirees" => "RC31",
    "IN - Indiana-Kentucky Council 962" => "C962",
    "IN - Indiana Retirees" => "RC9962",
    "KS - KOSE" => "L300",
    "KY - Indiana-Kentucky Council 962" => "C962",
    "KY - Missouri &amp; Kansas Council 72" => "C72",
    "LA - Louisiana Public Employees Council 17" => "C17",
    "MA - AFSCME Council 93" => "C93",
    "MA - Union of Social Workers" => "L1798",
    "MA - Harvard Clerical &amp; Tech Workers" => "L3650",
    "MA - SHARE Local 3900" => "L3900",
    "MA - SHARE Local 4000" => "L4000",
    "MA - Massachusetts Public Employees Retiree Chapter 93" => "RC93",
    "MD - Maryland Council 3" => "C3",
    "MD - Maryland Public Employees Council 67" => "C67",
    "MD - Prince George's County Public Service Employees" => "L2250",
    "MD - Maryland Public Employees Retiree Chapter 1" => "RC1",
    "MD - ACE/AFSCME Retirees Sub-Chapter 2250" => "RSC2250",
    "ME - AFSCME Council 93" => "C93",
    "ME - Maine Public Employees Retiree Chapter 93" => "RC93",
    "MI - Michigan Council 25" => "C25",
    "MI - Michigan State Employees Association" => "L5",
    "MI - Michigan Organizing Chapter 9925" => "RC9925",
    "MN - Minnesota Council Number 5" => "C5",
    "MN - Minnesota and Dakotas Council 65" => "C65",
    "MN - Minnesota Retirees United" => "RC5",
    "MN - Minnesota Retirees Chapter 65" => "RC65",
    "MO - Missouri &amp; Kansas Council 72" => "C72",
    "MO - Kansas City Public Employees" => "L500",
    "MO - Missouri Retirees Chapter" => "RC9972",
    "MT - Montana State Council 9" => "C9",
    "MT - Montana Retirees Public Employees Retiree Chapter 9" => "RC9",
    "NC - Duke University Employees" => "L77",
    "NC - North Carolina AFSCME Retirees" => "RSC165",
    "ND - Minnesota and Dakotas Council 65" => "C65",
    "NE - Lancaster County Courthouse Employees" => "L2468",
    "NE - Nebraska Public Employees" => "L251",
    "NE - Nebraska Association of Public Employees" => "L61",
    "NE - NAPE Retiree Chapter 161" => "RC161",
    "NH - AFSCME Council 93" => "C93",
    "NH - New Hampshire Public Employees Retiree Chapter 93" => "RC93",
    "NJ - New Jersey Public Employees Council 1" => "C1",
    "NJ - Northern New Jersey Council 52" => "C52",
    "NJ - Southern New Jersey District Council 71" => "C71",
    "NJ - Central New Jersey District Council 73" => "C73",
    "NJ - New Jersey Sub-Chapter 1 Retirees" => "RSC9901",
    "NJ - 1199J Retired Members Division" => "RC1199",
    "NM - New Mexico Public Employees Council 18" => "C18",
    "NM - New Mexico Public Employees Retiree Chapter 18" => "RC18",
    "NT - NUHHCE Local 1199" => "L1199",
    "NV - AFSCME Local 4041" => "L4041",
    "NV - SNEA/AFSCME Retirees Chapter 4041" => "RC4041",
    "NY - District Council 1707" => "C1707",
    "NY - Buffalo District Council 35" => "C35",
    "NY - New York City District Council 37" => "C37",
    "NY - New York County Municipal Employees" => "C66",
    "NY - New York State Law Enforcement Officers Union" => "C82",
    "NY - Civil Service Employees Association (CSEA)" => "L1000",
    "NY - Retiree Division CSEA Chapter 1000" => "RC1000",
    "NY - District Council 1707 Retirees" => "RC1707",
    "NY - Buffalo New York Retirees Chapter 35" => "RC35",
    "NY - Retirees Association of NYC District Counicl 37" => "RC37",
    "NY - New York State Law Enforcement Retirees" => "RC82",
    "OH - Ohio Council 8" => "C8",
    "OH - Ohio Civil Service Employees Association" => "L11",
    "OH - Ohio Association of Public Service Employees Local 4" => "L4",
    "OH - Ohio AFSCME Retiree Chapter" => "RC1184",
    "OK - Enid Oklahoma City Employees" => "L1136",
    "OK - Tulsa Public Employees Union" => "L1180",
    "OK - Local 2406" => "L2406",
    "OK - Muskogee Oklahoma Municipal Employees" => "L2465",
    "OK - Norman Oklahoma City Employees" => "L2875",
    "OR - Oregon AFSCME Council 75" => "C75",
    "OR - Oregon Public Retirees" => "RC75",
    "PA - Pennsylvania Public Employees Council 13" => "C13",
    "PA - District Council 33" => "C33",
    "PA - Admin Professional &amp; Tech Employees Council 47" => "C47",
    "PA - Southwestern PA Public Employees District Council 83" => "C83",
    "PA - Western PA Public Employees District Council 84" => "C84",
    "PA - Northwestern PA Public Employees District Council 85" => "C85",
    "PA - North Central PA Public Employees District Council 86" => "C86",
    "PA - Northeastern PA Public Employees District Council 87" => "C87",
    "PA - Southeastern PA Public Employees District Council 88" => "C88",
    "PA - Southern PA Public Employees District Council 89" => "C89",
    "PA - Dauphin County PA Public Employees District Council 90" => "C90",
    "PA - 1199C Retired Members Division" => "RC1199",
    "PA - Retired Public Employees PA Chapter 13" => "RC13",
    "PA - Golden Age Club" => "RC2",
    "PA - Philadelphia Retirees Chapter 47" => "RC47",
    "PR - SPUPR/AFSCME Council 95" => "C95",
    "PR - United Public Workers of Puerto Rico" => "RC95",
    "RI - Rhode Island Council 94" => "C94",
    "RI - AFSCME Rhode Island Retirees" => "RC94",
    "SD - Minnesota and Dakotas Council 65" => "C65",
    "TN - Memphis Public Employees Union" => "L1733",
    "TN - Brushy Mt State Prison Employees" => "L2173",
    "TX - AFSCME Texas Correctional Employees Council 7" => "C7",
    "TX - HOPE" => "L123",
    "TX - AFSCME Local 1550" => "L1550",
    "TX - Central Texas Public Employees Local 1624" => "L1624",
    "TX - El Paso Texas Public Employees" => "L59",
    "TX - Texas Public Retirees Chapter 12" => "RC12",
    "TX - Houston Public Employees Retiree Chapter 1550" => "RC1550",
    "UT - Utah Public Employees" => "L1004",
    "VA - Virginia State Employees Council 27" => "C27",
    "VA - Virginia Public Employees Union Local 3001" => "L3001",
    "VT - AFSCME Council 93" => "C93",
    "VT - Vermont Public Employees Retiree Chapter 93" => "RC93",
    "WA - Washington State County &amp; City Employees Council 2" => "C2",
    "WA - Washington Federation of State Employees Council 28" => "C28",
    "WA - Retired Public Employees Council" => "RC10",
    "WI - Wisconsin Council 32" => "C32",
    "WI - Wisconsin Retired Public Employees" => "RC32",
    "WV - AFSCME West Virginia Council 77" => "C77",
    "WV - West Virginia Public Employees Retirees Chapter 77" => "RC77",
    "Unknown" => "Other/None/Don't Know" 
  }

  
  def send_admin_emails
    AdminMailer.new_user_waiting_for_approval(self).deliver
    AdminMailer.notification_to_approvers(self, User.approvers).deliver
  end

  def send_account_notification(status)
    case status
    when 'approved'
        AdminMailer.send_account_activation(self).deliver
        self.send_reset_password_instructions
    when 'rejected'
        AdminMailer.send_account_rejection(self).deliver
    when 'unapproved'
        AdminMailer.send_account_suspension(self).deliver
    end
  end


  def name
    "#{first_name} #{last_name}"
  end

  def password_required?
    #having trouble with this when admins are un-approving a current user that was previously approved
    false
    ##self.approved? ? true : false
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  def admin?
    self.role == 'Administrator'
  end

  ## auth methods for devise
  def active_for_authentication? 
    super && approved? 
  end 

  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super # Use whatever other message 
    end 
  end
  ## end of auth methods for devise

  class << self
    def current_user=(current_user)
      Thread.current[:current_user] = current_user
    end

    def current_user
      Thread.current[:current_user]
    end
  end

end
