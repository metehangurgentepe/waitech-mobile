import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waitech/blocs/basket/basket_bloc.dart';

class BasketScreen extends StatefulWidget {
  static const String routeName = '/basket';

  const BasketScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => BasketScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<BasketScreen> createState() => _BasketState();
}

class _BasketState extends State<BasketScreen>{


  TextEditingController notController = TextEditingController();


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sepet'),

        actions: <Widget>[
          BlocBuilder<BasketBloc,BasketState>(
              builder: (context,state){
                if(state is BasketLoading){
                  return Center(
                    child: Text('ürün yok'),
                  );
                }
                if(state is BasketLoaded){
                 return IconButton(onPressed: (){
                    for(int i=0;i<state.basket.itemQuantity(state.basket.items).length;i++){
                      context.read<BasketBloc>()..add(RemoveItem(state.basket.itemQuantity(state.basket.items).keys.elementAt(i)));
                    }

                    }, icon: Icon(Icons.delete));
                }
                else{return Text('ürün yok');}

    }
              )

        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 8, 11, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              BlocBuilder<BasketBloc, BasketState>(
                builder: (context, state) {
                  if (state is BasketLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is BasketLoaded &&
                      state.basket
                          .itemQuantity(state.basket.items)
                          .isNotEmpty) {
                    return Text(
                      'Toplam Fiyat: ${state.basket.totalString}₺',
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                    );
                  } else {
                    return Text('');
                  }
                },
              ),
              OutlinedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).canvasColor,
                  fixedSize: const Size(120, 40),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                child: TextButton(
                    onPressed: () { Navigator.pushNamed(context, '/pay_screen'); },
                    child:Text(
                      "Devam".toUpperCase(),
                      style: const TextStyle(fontSize: 18,color: Colors.white),)

                ),
              )
            ],
          ),
        ),
      ),
      body: Padding(padding:  EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'Ürünler',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Segoe_UI',
                color:Colors.black38,
              ),
            ),
            SizedBox(height: 20),
            BlocBuilder<BasketBloc, BasketState>(
                builder: (context, state) {
                  if(state is BasketLoading){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else if(state is BasketLoaded) {
                    return state.basket.items.length ==0 ? Container(width: double.infinity,
                    margin: const EdgeInsets.only(top:5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child:Row(
                        children: [
                          Text('Sepetinizde ürün bulunmamaktadır',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.actor(
                              fontSize: 16,
                            ),

                          )
                        ],
                      ) ,
                    )
                    :ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.basket.itemQuantity(state.basket.items).keys.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0)),
                            child: Row(
                              children: [
                                Text('${state.basket.itemQuantity(state.basket.items).entries.elementAt(index).value} x',
                                  style: TextStyle(
                                    fontFamily: 'Monoton-Regular',
                                    fontSize: 20,
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 20),

                                Expanded(
                                  child:
                                  Column(
                                    children:  [
                                      Text('${state.basket.itemQuantity(state.basket.items).keys.elementAt(index).name}',
                                        style: TextStyle(
                                          fontFamily: 'Monoton-Regular',
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text('${state.basket.itemQuantity(state.basket.items).keys.elementAt(index).price}₺',
                                        style: TextStyle(
                                          fontFamily: 'Monoton-Regular',
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Row(
                                  children: [
                                    IconButton(onPressed: (){
                                      context.read<BasketBloc>()..add(RemoveItem(state.basket.itemQuantity(state.basket.items).keys.elementAt(index)));
                                    },
                                      icon: Icon(Icons.remove, color: Theme
                                          .of(context)
                                          .primaryColor),
                                    ),
                                    IconButton(onPressed: (){ context.read<BasketBloc>()..add(AddItem(state.basket.itemQuantity(state.basket.items).keys.elementAt(index)));
                                      },
                                      icon: Icon(Icons.add, color: Theme
                                          .of(context)
                                          .primaryColor),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  }
                  else{return Text('something wrong');}

            }),

            const SizedBox(height: 20),
          const SizedBox(
                height: 300,
                child:TextField(
                    decoration: InputDecoration(
                      filled: true,
                    hintText: 'Not Bırakın',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                )
          )
      ])
    )
    );


  }
}
