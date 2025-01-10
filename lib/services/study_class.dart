class Study {
  List<Studies>? studies;
  String? nextPageToken;

  Study({this.studies, this.nextPageToken});

  Study.fromJson(Map<String, dynamic> json) {
    if (json['studies'] != null) {
      studies =
          (json['studies'] as List).map((v) => Studies.fromJson(v)).toList();
    }
    nextPageToken = json['nextPageToken'];
  }

  Map<String, dynamic> toJson() {
    return {
      if (studies != null) 'studies': studies!.map((v) => v.toJson()).toList(),
      'nextPageToken': nextPageToken,
    };
  }
}

class Studies {
  ProtocolSection? protocolSection;
  bool? hasResults;

  Studies({this.protocolSection, this.hasResults});

  Studies.fromJson(Map<String, dynamic> json) {
    protocolSection = json['protocolSection'] != null
        ? ProtocolSection.fromJson(json['protocolSection'])
        : null;
    hasResults = json['hasResults'];
  }

  Map<String, dynamic> toJson() {
    return {
      if (protocolSection != null) 'protocolSection': protocolSection!.toJson(),
      'hasResults': hasResults,
    };
  }
}

class ProtocolSection {
  IdentificationModule? identificationModule;
  OutcomesModule? outcomesModule;
  ContactsLocationsModule? contactsLocationsModule;

  ProtocolSection({
    this.identificationModule,
    this.outcomesModule,
    this.contactsLocationsModule,
  });

  ProtocolSection.fromJson(Map<String, dynamic> json) {
    identificationModule = json['identificationModule'] != null
        ? IdentificationModule.fromJson(json['identificationModule'])
        : null;
    outcomesModule = json['outcomesModule'] != null
        ? OutcomesModule.fromJson(json['outcomesModule'])
        : null;
    contactsLocationsModule = json['contactsLocationsModule'] != null
        ? ContactsLocationsModule.fromJson(json['contactsLocationsModule'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      if (identificationModule != null)
        'identificationModule': identificationModule!.toJson(),
      if (outcomesModule != null) 'outcomesModule': outcomesModule!.toJson(),
      if (contactsLocationsModule != null)
        'contactsLocationsModule': contactsLocationsModule!.toJson(),
    };
  }
}

class IdentificationModule {
  String? nctId;
  OrgStudyIdInfo? orgStudyIdInfo;
  Organization? organization;
  String? briefTitle;
  String? officialTitle;
  List<SecondaryIdInfos>? secondaryIdInfos;
  String? acronym;

  IdentificationModule({
    this.nctId,
    this.orgStudyIdInfo,
    this.organization,
    this.briefTitle,
    this.officialTitle,
    this.secondaryIdInfos,
    this.acronym,
  });

  IdentificationModule.fromJson(Map<String, dynamic> json) {
    nctId = json['nctId'];
    orgStudyIdInfo = json['orgStudyIdInfo'] != null
        ? OrgStudyIdInfo.fromJson(json['orgStudyIdInfo'])
        : null;
    organization = json['organization'] != null
        ? Organization.fromJson(json['organization'])
        : null;
    briefTitle = json['briefTitle'];
    officialTitle = json['officialTitle'];
    if (json['secondaryIdInfos'] != null) {
      secondaryIdInfos = (json['secondaryIdInfos'] as List)
          .map((v) => SecondaryIdInfos.fromJson(v))
          .toList();
    }
    acronym = json['acronym'];
  }

  Map<String, dynamic> toJson() {
    return {
      'nctId': nctId,
      if (orgStudyIdInfo != null) 'orgStudyIdInfo': orgStudyIdInfo!.toJson(),
      if (organization != null) 'organization': organization!.toJson(),
      'briefTitle': briefTitle,
      'officialTitle': officialTitle,
      if (secondaryIdInfos != null)
        'secondaryIdInfos': secondaryIdInfos!.map((v) => v.toJson()).toList(),
      'acronym': acronym,
    };
  }
}

class OrgStudyIdInfo {
  String? id;

  OrgStudyIdInfo({this.id});

  OrgStudyIdInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class Organization {
  String? fullName;
  String? classes;

  Organization({this.fullName, this.classes});

  Organization.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    classes = json['class'];
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'class': classes,
    };
  }
}

class SecondaryIdInfos {
  String? id;
  String? type;
  String? domain;

  SecondaryIdInfos({this.id, this.type, this.domain});

  SecondaryIdInfos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    domain = json['domain'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'domain': domain,
    };
  }
}

class OutcomesModule {
  List<PrimaryOutcomes>? primaryOutcomes;

  OutcomesModule({this.primaryOutcomes});

  OutcomesModule.fromJson(Map<String, dynamic> json) {
    if (json['primaryOutcomes'] != null) {
      primaryOutcomes = (json['primaryOutcomes'] as List)
          .map((v) => PrimaryOutcomes.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (primaryOutcomes != null)
        'primaryOutcomes': primaryOutcomes!.map((v) => v.toJson()).toList(),
    };
  }
}

class PrimaryOutcomes {
  String? measure;
  String? description;
  String? timeFrame;

  PrimaryOutcomes({this.measure, this.description, this.timeFrame});

  PrimaryOutcomes.fromJson(Map<String, dynamic> json) {
    measure = json['measure'];
    description = json['description'];
    timeFrame = json['timeFrame'];
  }

  Map<String, dynamic> toJson() {
    return {
      'measure': measure,
      'description': description,
      'timeFrame': timeFrame,
    };
  }
}

class ContactsLocationsModule {
  List<OverallOfficials>? overallOfficials;
  List<Locations>? locations;

  ContactsLocationsModule({this.overallOfficials, this.locations});

  ContactsLocationsModule.fromJson(Map<String, dynamic> json) {
    if (json['overallOfficials'] != null) {
      overallOfficials = (json['overallOfficials'] as List)
          .map((v) => OverallOfficials.fromJson(v))
          .toList();
    }
    if (json['locations'] != null) {
      locations = (json['locations'] as List)
          .map((v) => Locations.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (overallOfficials != null)
        'overallOfficials': overallOfficials!.map((v) => v.toJson()).toList(),
      if (locations != null)
        'locations': locations!.map((v) => v.toJson()).toList(),
    };
  }
}

class OverallOfficials {
  String? name;
  String? affiliation;
  String? role;

  OverallOfficials({this.name, this.affiliation, this.role});

  OverallOfficials.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    affiliation = json['affiliation'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'affiliation': affiliation,
      'role': role,
    };
  }
}

class Locations {
  String? facility;
  String? city;
  String? state;
  String? zip;
  String? country;
  GeoPoint? geoPoint;
  String? status;
  List<Contacts>? contacts;

  Locations({
    this.facility,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.geoPoint,
    this.status,
    this.contacts,
  });

  Locations.fromJson(Map<String, dynamic> json) {
    facility = json['facility'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    country = json['country'];
    geoPoint =
        json['geoPoint'] != null ? GeoPoint.fromJson(json['geoPoint']) : null;
    status = json['status'];
    if (json['contacts'] != null) {
      contacts =
          (json['contacts'] as List).map((v) => Contacts.fromJson(v)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'facility': facility,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      if (geoPoint != null) 'geoPoint': geoPoint!.toJson(),
      'status': status,
      if (contacts != null)
        'contacts': contacts!.map((v) => v.toJson()).toList(),
    };
  }
}

class GeoPoint {
  double? lat;
  double? lon;

  GeoPoint({this.lat, this.lon});

  GeoPoint.fromJson(Map<String, dynamic> json) {
    lat = (json['lat'] as num?)?.toDouble();
    lon = (json['lon'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lon': lon,
    };
  }
}

class Contacts {
  String? name;
  String? role;
  String? phone;
  String? email;

  Contacts({this.name, this.role, this.phone, this.email});

  Contacts.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    role = json['role'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'phone': phone,
      'email': email,
    };
  }
}




// class Study {
//   final String? studyId;
//   final String? studyDescription;
//   final List? location;

//   // Add other relevant fields

//   Study({
//     required this.studyId,
//     required this.studyDescription,
//     required this.location,

//     // Initialize other fields
//   });

//   factory Study.fromJson(Map<String, dynamic> json) {
//     return Study(
//       studyId: json['protocolSection']['identificationModule']['nctId'],
//       studyDescription: json['protocolSection']['descriptionModule']
//           ['briefSummary'],
//       location: json['protocolSection']?['contactsLocationsModule']
//           ?['locations'],
//       // Parse other fields
//     );
//   }
// }

