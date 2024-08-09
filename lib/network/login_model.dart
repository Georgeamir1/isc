class LoginModel{
   bool status = false;
   String  message = '';
   UserData ? date ;
   LoginModel.fromjson(Map<String,dynamic >json)
   {
     status =json['status'];
     message =json['message'];
     date =json['date'] !=null?  UserData.fromjson(json['data']) : null ;
   }
}
class UserData {
   int? id;
   int? points;
   int? credits;
   String? name;
   String? email;
   String? phone;
   String? image;
   String? token;

UserData.fromjson(Map<String,dynamic> json)
{
  id =  json['id'];
  name =  json['name'];
  email =  json['email'];
  phone =  json['phone'];
  image =  json['image'];
  points =  json['points'];
  credits =  json['credits'];
  token =  json['token'];
}
}
