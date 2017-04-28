HashMap<Long, iTangible> tangibleMap; // Change name to stellarMap

void SetupStarMap() { // Change name !!!!!!!
  tangibleMap = new HashMap<Long, iTangible>();
}

HashMap<Long, Cursor> cursorMap;

void SetupCursorMap() {
  cursorMap = new HashMap<Long, Cursor>();
}


HashMap<Integer, StellarObject> idToType; // This matches integers to Stellar Objects

void SetupIdToType() {
  idToType = new HashMap<Integer, StellarObject>();

  idToType.put(80, StellarObject.YELLOW); 
  idToType.put(54, StellarObject.RED_DWARF); 
  idToType.put(98, StellarObject.BLUE); 
  idToType.put(67, StellarObject.BLACK_HOLE);
  idToType.put(25, StellarObject.LEARN_SCREEN);
}