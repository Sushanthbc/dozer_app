part of dozer;

class KcImageViewer extends StatelessWidget{

  final String imageURL;

  KcImageViewer({Key key, this.imageURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
      ),
      body: new Image.network(
        imageURL,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}