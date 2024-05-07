namespace SkillInventory.Models
{
    public class Charts
    {
        public string SkillName { get; set; }
        public string Employee { get; set; }
        public string Beginner { get; set; }
        public string Intermediate { get; set; }
        public string Expert { get; set; }
    }
    public class ChartsViewModel
    {
        public List<Charts> ChartsList { get; set; }
        public ChartsViewModel()
        {
            ChartsList = new List<Charts>(); // Initialize an empty list
        }

        public string[] SkillNames { get; set; }
        public string Employee { get; set; }
        public string Beginner { get; set; }
        public string Intermediate { get; set; }
        public string Expert { get; set; }
        public string SkillCount { get; set; }
        public string[] ProficiencyLevels { get; set; }
    }

}
