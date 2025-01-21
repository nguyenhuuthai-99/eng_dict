import 'dart:ffi';

class CodeTable {
  static final Map<String, dynamic> dictionaryLabels = {
    "Adjectives": {
      "adjective": "A word that describes a noun or pronoun",
      "[after noun]": "An adjective that only follows a noun.",
      "[after verb]": "An adjective that only follows a verb.",
      "[before noun]": "An adjective that only goes before a noun.",
      "comparative":
          "The form of an adjective or adverb that expresses a difference in amount, number, degree, or quality.",
      "superlative":
          "The form of an adjective or adverb that expresses that the thing or person being described has more of the particular quality than anything or anyone else of the same type.",
      "[not gradable]":
          "An adjective that has no comparative or superlative form."
    },
    "Nouns": {
      "noun": "A word that refers to a person, place or thing.",
      "[C]": "Countable noun: a noun that has a plural.",
      "[U]": "Uncountable or singular noun: a noun that has no plural.",
      "[S]": "A singular noun.",
      "plural": "The plural form of a noun.",
      "noun [plural]": "A noun that can only be used in the plural.",
      "[usually plural]": "A noun usually used in the plural.",
      "[usually singular]": "A countable noun usually used in the singular.",
      "[+ sing/pl verb]":
          "A noun that refers to a group of people acting collectively. When used in the singular it can be followed by either a singular or a plural verb in British English. In American English a singular verb is preferred."
    },
    "Verbs": {
      "verb": "A word that describes an action, state or experience.",
      "[T]": "Transitive verb: a verb that has an object.",
      "[I]": "Intransitive verb: a verb that has no object.",
      "auxiliary verb":
          "The verbs be, have and do, which combine with other verbs to make different forms like passives, questions and the continuous.",
      "modal verb":
          "Verbs, such as must and can, that add meaning such as certainty and obligation.",
      "past simple": "The past simple form of the verb (eat ate eaten).",
      "past participle": "The past participle of the verb (eat ate eaten).",
      "present participle": "The present participle of the verb (tying tied).",
      "phrasal verb": "A verb followed by an adverb or a preposition.",
      "[L]":
          "Linking verb: an intransitive verb that is followed by a noun or adjective that refers back to the subject of the sentence.",
      "[L only + adjective]": "A linking verb only followed by an adjective.",
      "[L only + noun]": "A linking verb only followed by a noun.",
      "[+ adv/prep]":
          "A verb that must be followed by an adverb or preposition.",
      "[+ that clause]": "A verb followed by a clause beginning with that.",
      "[+ question word]": "A verb followed by a question word.",
      "[+ speech]": "A verb used with direct speech.",
      "[+ to infinitive]": "A verb followed by the infinitive with to.",
      "[+ infinitive without to]":
          "A verb followed by the infinitive without to.",
      "[+ -ing] verb": "A verb followed by the -ing form of the verb.",
      "[+ not or so]":
          "A verb followed immediately by not or so where these replace a clause.",
      "[+ two objects]": "A verb that has a direct and indirect object.",
      "[+ obj + adjective]": "A verb with an object followed by an adjective.",
      "[+ obj + noun]": "A verb with an object followed by a noun.",
      "[+ obj + noun or adjective]":
          "A verb with an object followed by a noun or adjective.",
      "[+ obj + as noun or adjective]":
          "A verb with an object followed by as and a noun or an adjective.",
      "[+ obj + to be noun or adjective]":
          "A verb with an object followed by to be and a noun or an adjective.",
      "[+ obj + that clause]":
          "A verb with an object followed by a that clause.",
      "[+ obj + to infinitive]":
          "A verb with an object followed by an infinitive with to.",
      "[+ obj + infinitive without to]":
          "A verb with an object followed by an infinitive without to.",
      "[+ obj + past participle]":
          "A verb with an object followed by a past participle.",
      "[+ obj + ing verb]":
          "A verb with an object followed by the -ing form of a verb.",
      "[+ obj + question word]":
          "A verb with an object followed by a question word.",
      "[usually passive]": "A verb usually used in the passive.",
      "[not continuous]": "A verb not used in the continuous form."
    },
    "Other labels": {
      "adverb":
          "A word that gives information about a verb, adjective, another adverb, or a sentence.",
      "conjunction":
          "A word such as and or although used to link two parts of a sentence.",
      "determiner":
          "A word such as the or this used before a noun to show which particular example of a noun is being referred to.",
      "number": "A word that refers to a number.",
      "ordinal number":
          "A number such as 1st, 2nd, 3rd, 4th, that shows the position of something in a list of things.",
      "preposition":
          "A word that is used before a noun, a noun phrase, or a pronoun, connecting it to another word.",
      "predeterminer":
          "A word such as both or all used before other determiners.",
      "pronoun": "A word such as it, or mine used to replace a noun.",
      "prefix":
          "A letter or group of letters such as un-, pre- or anti- added to the beginning of a word to make a new word.",
      "suffix":
          "A letter or group of letters such as -less or -ment added to the end of a word to make a new word.",
      "exclamation":
          "A word or expression such as damn! or oh dear! used to express strong feelings.",
      "[+ ing verb]": "A word or phrase followed by the -ing form of the verb.",
      "[+ to infinitive]":
          "A word or phrase followed by the infinitive with to.",
      "[+ that]": "A word or phrase followed by a clause beginning with that.",
      "[+ question word]": "A word or phrase followed by a question word.",
      "[as form of address]":
          "A word or phrase such as Mr or dear used to address someone."
    }
  };

  // String getCodeString(String form, String code) {
  //   if (form == "adjective") {
  //   } else if (form == "noun") {
  //   } else if (form == "verb") {
  //   } else {}
  // }
  //
  // String getAdjective(String code) {
  //   Set<Char> codeSet = parseCode(code);
  // }
  //
  // Set<Char> parseCode(String code) {}
}
