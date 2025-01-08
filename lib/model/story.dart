enum StoryLevel{beginner, intermediate, advanced}

class Story {
  late String title;
  late String author;
  late String reference;
  late String summary;
  late String genre;
  late String content;
  late StoryLevel level;

  Story({required this.title, required this.author, required this.reference,required summary, required this.genre, required this.content, required this.level});
}