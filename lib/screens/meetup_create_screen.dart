import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:meetups_app/models/category.dart';
import 'package:meetups_app/models/forms.dart';
import 'package:meetups_app/screens/meetup_detail_screen.dart';
import 'package:meetups_app/screens/meetup_home_screen.dart';
import 'package:meetups_app/services/meetup_api_provider.dart';
import 'package:meetups_app/utils/generate_times.dart';
import 'package:meetups_app/utils/hypotenuse.dart';
import 'package:meetups_app/widgets/select_input.dart';

class MeetupCreateScreen extends StatefulWidget {
  static final String route = '/meetupCreate';

  MeetupCreateScreenState createState() => MeetupCreateScreenState();
}

class MeetupCreateScreenState extends State<MeetupCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _scaffoldContext;

  MeetupFormData _meetupFormData = MeetupFormData();
  MeetupApiService _api = MeetupApiService();
  List<Category> _categories = [];
  final List<String> _times = generateTimes();

  @override
  initState() {
    _api
        .fetchCategories()
        .then((categories) => setState(() => _categories = categories));

    super.initState();
  }

  _handleDateChange(DateTime selectedDate) {
    _meetupFormData.startDate = selectedDate;
  }

  void _submitCreate() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _api.createMeetup(_meetupFormData).then((String meetupId) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          MeetupDetailScreen.route,
          ModalRoute.withName('/'),
          arguments: MeetupDetailArguments(id: meetupId),
        );
      }).catchError((e) => print(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Crear Meetup')),
        body: Builder(builder: (context) {
          _scaffoldContext = context;
          return Padding(
              padding: EdgeInsets.all(hypotenuse(
                  MediaQuery.of(context).size.height * 0.04,
                  MediaQuery.of(context).size.width * 0.04)),
              child: _buildForm());
        }));
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          _buildTitle(),
          TextFormField(
            style: Theme.of(context).textTheme.headline,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            decoration: InputDecoration(
              hintText: 'Ubicación',
            ),
            onSaved: (value) => _meetupFormData.location = value,
          ),
          TextFormField(
            style: Theme.of(context).textTheme.headline,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            decoration: InputDecoration(
              hintText: 'Título',
            ),
            onSaved: (value) => _meetupFormData.title = value,
          ),
          _DatePicker(onDateChange: _handleDateChange),
          SelectInput<Category>(
              items: _categories,
              onChange: (Category c) => _meetupFormData.category = c,
              label: 'Categoría'),
          TextFormField(
            style: Theme.of(context).textTheme.headline,
            decoration: InputDecoration(
              hintText: 'Imagen',
            ),
            onSaved: (value) => _meetupFormData.image = value,
          ),
          TextFormField(
            style: Theme.of(context).textTheme.headline,
            inputFormatters: [LengthLimitingTextInputFormatter(100)],
            decoration: InputDecoration(
              hintText: 'Resumen',
            ),
            onSaved: (value) => _meetupFormData.shortInfo = value,
          ),
          TextFormField(
            style: Theme.of(context).textTheme.headline,
            inputFormatters: [LengthLimitingTextInputFormatter(200)],
            decoration: InputDecoration(
              hintText: 'Descripción',
            ),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            onSaved: (value) => _meetupFormData.description = value,
          ),
          SelectInput<String>(
              items: _times,
              onChange: (String t) => _meetupFormData.timeFrom = t,
              label: 'Desde'),
          SelectInput<String>(
              items: _times,
              onChange: (String t) => _meetupFormData.timeTo = t,
              label: 'Hasta'),
          _buildSubmitBtn()
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.06),
      child: Text(
        'Crea tu Meetup',
        style: TextStyle(
            fontSize: 30.0 * MediaQuery.of(context).textScaleFactor,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
        alignment: Alignment(-1.0, 0.0),
        child: Center(
          child: RaisedButton(
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            child: const Text('Enviar'),
            onPressed: _submitCreate,
          ),
        ));
  }
}

class _DatePicker extends StatefulWidget {
  final Function(DateTime date) onDateChange;

  _DatePicker({@required this.onDateChange});

  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<_DatePicker> {
  DateTime _dateNow = DateTime.now();
  DateTime _initialDate = DateTime.now();

  final TextEditingController _dateController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _initialDate,
        firstDate: _dateNow,
        lastDate: DateTime(_dateNow.year + 1, _dateNow.month, _dateNow.day));
    if (picked != null && picked != _initialDate) {
      widget.onDateChange(picked);
      setState(() {
        _dateController.text = _dateFormat.format(picked);
        _initialDate = picked;
      });
    }
  }

  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
          child: new TextFormField(
        enabled: false,
        decoration: new InputDecoration(
          icon: const Icon(Icons.calendar_today),
          hintText: 'Ingresa la fecha cuando inicia el meetup',
          labelText: 'Fecha',
        ),
        controller: _dateController,
        keyboardType: TextInputType.datetime,
      )),
      IconButton(
        icon: new Icon(Icons.more_horiz),
        tooltip: 'Elegir fecha',
        onPressed: (() {
          _selectDate(context);
        }),
      )
    ]);
  }
}
