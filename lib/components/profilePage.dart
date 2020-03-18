

import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';


class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}




class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);
    return Scaffold(
      body: Container(
        //backgroundcolor
        color: (!isDarkMode) ? Colors.white : Colors.black,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              backgroundColor: dynamicuicolor,
              elevation: 3.0,
              title: Text("Nick Frost",
              style: TextStyle(
                      color: (!isDarkMode) ? Colors.black : Colors.white)),
              actions: <Widget>[
                      IconButton(
                          icon:Icon(Icons.menu),
                          ),
                          ]

                          ),

                          SliverGrid.count(
                         crossAxisCount: 1,
                         children: <Widget>[
                         UserProfilePage(profilename:"Nick Frost",profileimageurl:'assets/Team_IC.jpg')
              ],
            )    

                          
                          ],
                    
             )
              
        ),











/*
          Column(
            children: <Widget>[
              Container(
                color:Colors.orange,
                margin: EdgeInsets.only(top:8.0),
                decoration:BoxDecoration(
                  color: Colors.white,
                ),
                )
            ]
              ),
          */
        
      );
    
  }
}
                      
 

  class UserProfilePage extends StatelessWidget {
   final String profileimageurl;
   final String profilename;
   final String bio= "SOftware developer";
   final String followers="173";
   final String following="200";
   final String posts="11";

   UserProfilePage({
    @required this.profilename,
    this.profileimageurl,

  });
    final String profiledefault =
      'https://www.searchpng.com/wp-content/uploads/2019/02/Deafult-Profile-Pitcher.png';
  @override
   
   @override 
   Widget build(BuildContext context) {
    return Container(
     // child: Align(
        //   alignment:Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[

              new Container(
             //  alignment:Alignment.topLeft,
               height:80,
               width:80,
              decoration: new BoxDecoration(
                color:Colors.grey,
                image:DecorationImage(
                image: new AssetImage('assets/Team_IC.jpg'),
                fit:BoxFit.cover,

                ),
                borderRadius: BorderRadius.circular(90.0),
                border: Border.all(
                  color: Colors.white,
                  width: 4.0,
                 ),
            ) ,            
          

           
          ),  
            
          new SizedBox(
           height: MediaQuery.of(context).size.height/4.5,
            width: 10,
         ), 

         Column(
           mainAxisAlignment:MainAxisAlignment.center,
           children: <Widget>[
            Text(followers,
              style:TextStyle(fontWeight: FontWeight.bold) 
            ),
            Text("Followers"),
   
           ]
           ),

         Column(
           mainAxisAlignment:MainAxisAlignment.center,
           children: <Widget>[
            Text(following,
              style:TextStyle(fontWeight: FontWeight.bold) 
            ),
            Text("Following"),
           
           ],
           ),

           Column(
           mainAxisAlignment:MainAxisAlignment.center,
           children: <Widget>[
            Text(posts,
              style:TextStyle(fontWeight: FontWeight.bold) 
            ),
            Text("Posts"),
           
           ],
         ),

           
           ],
           ) 


            


    
     //   )
      
     );

  }
}


  

/*

   Widget _buildCoverImage(Size screenSize){
     return Container(

          height: screenSize.height /3,
          decoration:BoxDecoration(
            image:DecorationImage(
              image:AssetImage('assets/Team_IC.jpg'),
                  fit:BoxFit.cover,
            ),
          ),
        );
  
  }

  @override 
  Widget build(Buildcontext Context) {
    size screenSize= MediaQuery.of(context).size.height;
    return Scaffold
  }*/
