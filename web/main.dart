import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'post_model.dart';

void main() {
  var body = document.getElementsByTagName("body").first;
  var form = document.getElementsByTagName("form").first as FormElement;
  var name = document.getElementById("name") as InputElement;
  var mail = document.getElementById("mail") as InputElement;
  var type = document.getElementById("type") as SelectElement;
  var message = document.getElementById("msg") as TextAreaElement;
  var postsLabelContainer = document.getElementById("posts") as DivElement;

  Storage localStorage = window.localStorage;
  SelectElement mainSelect = SelectElement();

  var nav = body.append(Element.nav()..children.add(UListElement()));

  if (localStorage.entries.isNotEmpty) {
    postModelFromMap(localStorage.entries).forEach((element) {
      nav.childNodes.first.append(createLiFromModel(element));
    });
    createFilterIfEmpty(postsLabelContainer,mainSelect, postModelFromMap(localStorage.entries).first,nav);
  } else {
    nav.childNodes.first.append(Element.p()
      ..text = "No posts yet, please create some."
      ..style.textAlign = "center"
      ..id = "error_text");
  }

  form.onSubmit.listen((event) {
    event.preventDefault();
    var errorText = nav.childNodes.first.childNodes
        .where((element) => (element as Element).id == "error_text");
    if (errorText.isNotEmpty) errorText.first.remove();
    var postModel = PostModel(
        name: name.value!,
        email: mail.value!,
        message: message.value!,
        type: type.value!);
    nav.childNodes.first.append(createLiFromModel(postModel));
    createFilterIfEmpty(postsLabelContainer,mainSelect,postModel,nav);
    localStorage
        .addEntries([MapEntry(getRandString(5), json.encode(postModel))]);
  });
}

LIElement createLiFromModel(PostModel postModel) {
  var returnList = LIElement()
    ..children.addAll([
      Element.p()
        ..text = "Name: "
        ..className = 'name'
        ..children.add(Element.span()
          ..text = postModel.name
          ..style.fontWeight = "bold"),
      Element.p()
        ..text = "E-mail: ${postModel.email}"
        ..className = "email",
      Element.p()
        ..text = "Type: ${postModel.type}"
        ..className = "type",
      Element.p()
        ..text = "Message: ${postModel.message}"
        ..style.paddingLeft = "200px"
        ..style.paddingRight = "200px"
        ..className = "message",
    ]);
  returnList.id = "list_posts";
  return returnList;
}

String getRandString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

SelectElement createSortingByFiltersElement(PostModel element) {
  var select = SelectElement()
    ..id = "post_select"
    ..style.width = "100px"
    ..style.marginTop = "25px"
    ..style.padding="10px";
  element.getElementsKeys().forEach((element) {
    select.append(OptionElement()..text = element);
  });
  return select;
}

void createFilterIfEmpty(
    DivElement div, SelectElement select, PostModel postModel, Node nav) {
  if (select.children.isEmpty) {
    select = createSortingByFiltersElement(postModel);
    div.append(select);
  }
  select.onChange.listen((event) {
    var value = select.selectedOptions.first.text;
    print(value);
    for (var parent in (nav.childNodes.first as Element).children) {
      for (var element in parent.children) {
        print(element.className);
        element.className == value
            ? element.hidden = false
            : element.hidden = true;
      }
    }
  });
}
