import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:meetups_app/models/category.dart';
import 'package:meetups_app/models/forms.dart';
import 'package:meetups_app/services/meetup_api_provider.dart';
import 'package:meetups_app/utils/hypotenuse.dart';

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

  _handleTimeFromChange(String time) {
    _meetupFormData.timeFrom = time;
  }

  _handleTimeToChange(String time) {
    _meetupFormData.timeTo = time;
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

  void handleSuccesfulCreate(dynamic data) async {
    // await Navigator
    //   .pushNamed(context, "/login",
    //              arguments: LoginScreenArguments('You have been succesfuly logged in!'));
  }

  void handleError(String message) {
    Scaffold.of(_scaffoldContext)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _submitCreate() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print(_meetupFormData.toJSON());
      print(_meetupFormData.startDate);
    }
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
          _CategorySelect(
              categories: _categories, meetupFormData: _meetupFormData),
          TextFormField(
            style: Theme.of(context).textTheme.headline,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
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
            onSaved: (value) => _meetupFormData.description = value,
          ),
          _TimeSelect(onTimeChange: _handleTimeFromChange, label: 'Desde'),
          _TimeSelect(onTimeChange: _handleTimeToChange, label: 'Hasta'),
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

class _CategorySelect extends StatelessWidget {
  final List<Category> categories;
  final MeetupFormData meetupFormData;

  _CategorySelect({@required this.categories, @required this.meetupFormData});

  Widget build(BuildContext context) {
    return FormField<Category>(
      builder: (FormFieldState<Category> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Categoría',
            icon: const Icon(Icons.color_lens),
          ),
          isEmpty: meetupFormData.category == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Category>(
              value: meetupFormData.category,
              isDense: true,
              onChanged: (Category newCategory) {
                meetupFormData.category = newCategory;
                state.didChange(newCategory);
              },
              items: categories.map((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
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
    if (picked != null && picked != _initialDate) widget.onDateChange(picked);
    setState(() {
      _dateController.text = _dateFormat.format(picked);
      _initialDate = picked;
    });
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

class _TimeSelect extends StatefulWidget {
  final Function(String) onTimeChange;
  final label;
  _TimeSelectState createState() => _TimeSelectState();

  _TimeSelect({@required this.onTimeChange, this.label});
}

class _TimeSelectState extends State<_TimeSelect> {
  final List<String> _times = [
    '00:00',
    '00:30',
    '01:00',
    '01:30',
    '02:00',
    '02:30',
    '03:00'
  ];
  String _selectedTime;

  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: const Icon(Icons.timer),
            labelText: widget.label ?? 'Hora',
          ),
          isEmpty: _selectedTime == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTime,
              isDense: true,
              onChanged: (String newTime) {
                widget.onTimeChange(newTime);
                _selectedTime = newTime;
                state.didChange(newTime);
              },
              items: _times.map((String time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
