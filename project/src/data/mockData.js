export const CITIES = ['Karachi','Lahore','Islamabad','Rawalpindi','Faisalabad','Peshawar','Quetta','Multan']

export const CITY_UR = { Karachi:'کراچی',Lahore:'لاہور',Islamabad:'اسلام آباد',Rawalpindi:'راولپنڈی',Faisalabad:'فیصل آباد',Peshawar:'پشاور',Quetta:'کوئٹہ',Multan:'ملتان' }

export const CATEGORIES = [
  {icon:'🔧',en:'Plumber',ur:'پلمبر'},
  {icon:'⚡',en:'Electrician',ur:'الیکٹریشن'},
  {icon:'❄️',en:'AC Repair',ur:'اے سی مرمت'},
  {icon:'🚗',en:'Car Repair',ur:'گاڑی مرمت'},
  {icon:'🧹',en:'Cleaner',ur:'صفائی'},
  {icon:'💧',en:'Water Tanker',ur:'واٹر ٹینکر'},
  {icon:'🚖',en:'Driver',ur:'ڈرائیور'},
  {icon:'🚙',en:'Rent Car',ur:'کرایے کی گاڑی'},
  {icon:'📚',en:'Tutor',ur:'ٹیوٹر'},
]

export const PROVIDERS = [
  { id:'p1',name:'Muhammad Ali',phone:'0300-1234567',city:'Karachi',serviceType:'Plumber',serviceTypeUr:'پلمبر',rating:4.8,pricePerHour:800,distanceKm:1.2,isVerified:true,rank:'Gold',totalEarnings:145000,totalOrders:187,avatar:'MA',photo:'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=200',lat:24.8607,lng:67.0011 },
  { id:'p2',name:'Asif Khan',phone:'0311-1234567',city:'Karachi',serviceType:'Electrician',serviceTypeUr:'الیکٹریشن',rating:4.5,pricePerHour:900,distanceKm:2.1,isVerified:true,rank:'Silver',totalEarnings:98000,totalOrders:122,avatar:'AK',photo:'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=200',lat:24.8700,lng:67.0200 },
  { id:'p3',name:'Rashid Mehmood',phone:'0321-1234567',city:'Lahore',serviceType:'AC Repair',serviceTypeUr:'اے سی مرمت',rating:4.9,pricePerHour:1200,distanceKm:0.8,isVerified:true,rank:'Gold',totalEarnings:210000,totalOrders:245,avatar:'RM',photo:'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=200',lat:31.5204,lng:74.3587 },
  { id:'p4',name:'Tariq Hussain',phone:'0331-1234567',city:'Islamabad',serviceType:'Cleaner',serviceTypeUr:'صفائی',rating:4.3,pricePerHour:600,distanceKm:3.5,isVerified:false,rank:'Bronze',totalEarnings:45000,totalOrders:56,avatar:'TH',photo:null,lat:33.7294,lng:73.0931 },
  { id:'p5',name:'Imran Shah',phone:'0345-1234567',city:'Karachi',serviceType:'Car Repair',serviceTypeUr:'گاڑی مرمت',rating:4.7,pricePerHour:1500,distanceKm:1.9,isVerified:true,rank:'Silver',totalEarnings:132000,totalOrders:98,avatar:'IS',photo:'https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=200',lat:24.8550,lng:67.0150 },
  { id:'p6',name:'Zubair Ahmed',phone:'0356-1234567',city:'Lahore',serviceType:'Tutor',serviceTypeUr:'ٹیوٹر',rating:4.6,pricePerHour:700,distanceKm:2.8,isVerified:true,rank:'Silver',totalEarnings:76000,totalOrders:134,avatar:'ZA',photo:'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&w=200',lat:31.5350,lng:74.3700 },
  { id:'p7',name:'Hamid Raza',phone:'0312-9876543',city:'Islamabad',serviceType:'Plumber',serviceTypeUr:'پلمبر',rating:4.4,pricePerHour:750,distanceKm:1.5,isVerified:true,rank:'Silver',totalEarnings:88000,totalOrders:110,avatar:'HR',photo:null,lat:33.7200,lng:73.1000 },
  { id:'p8',name:'Fahad Iqbal',phone:'0333-5551234',city:'Karachi',serviceType:'Driver',serviceTypeUr:'ڈرائیور',rating:4.9,pricePerHour:1000,distanceKm:0.5,isVerified:true,rank:'Gold',totalEarnings:190000,totalOrders:300,avatar:'FI',photo:null,lat:24.8620,lng:67.0050 },
]

export const MOCK_ORDERS = [
  { id:'o1',customerName:'Sara Ahmed',serviceType:'Plumber',distanceKm:1.2,totalPrice:1680,status:'new',paymentMethod:'JazzCash',isPaid:true,time:'15 min ago' },
  { id:'o2',customerName:'Bilal Raza',serviceType:'Plumber',distanceKm:2.5,totalPrice:2400,status:'accepted',paymentMethod:'COD',isPaid:false,time:'1 hr ago' },
  { id:'o3',customerName:'Nadia Malik',serviceType:'Plumber',distanceKm:0.9,totalPrice:1200,status:'completed',paymentMethod:'JazzCash',isPaid:true,time:'3 hrs ago' },
  { id:'o4',customerName:'Kamran Ali',serviceType:'Plumber',distanceKm:3.2,totalPrice:960,status:'cancelled',paymentMethod:'COD',isPaid:false,time:'5 hrs ago' },
]

export const NOTIFICATIONS = [
  { id:1,key:'booking_confirmed_notif',icon:'✅',color:'#22C55E',time:'2 min ago',read:false },
  { id:2,key:'provider_on_way_notif',icon:'🛵',color:'#3B82F6',time:'15 min ago',read:false },
  { id:3,key:'payment_received_notif',icon:'💰',color:'#006633',time:'1 hr ago',read:true },
  { id:4,key:'order_cancelled_notif',icon:'❌',color:'#EF4444',time:'3 hrs ago',read:true },
  { id:5,key:'booking_confirmed_notif',icon:'✅',color:'#22C55E',time:'Yesterday',read:true },
  { id:6,key:'payment_received_notif',icon:'💰',color:'#006633',time:'Yesterday',read:true },
]

export const MOCK_MESSAGES = [
  { id:'m1',from:'other',text:'Asalamu Alaikum, kya hal hai?',time:'10:05',read:true },
  { id:'m2',from:'me',text:'Walaikum Asalam! Theek hoon. Service kab available hai?',time:'10:07',read:true },
  { id:'m3',from:'other',text:'Aaj shaam 5 baje. Rs. 800/hr hoga.',time:'10:09',read:true },
  { id:'m4',from:'me',text:'Theek hai, confirm karta hoon. 👍',time:'10:12',read:false },
]

export const rankColor = (rank) => rank==='Gold'?'#FFD700':rank==='Silver'?'#C0C0C0':'#CD7F32'
