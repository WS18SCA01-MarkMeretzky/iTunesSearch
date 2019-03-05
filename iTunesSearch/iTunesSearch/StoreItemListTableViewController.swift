
import UIKit;

class StoreItemListTableViewController: UITableViewController {
    var storeItemController: StoreItemController = StoreItemController(); //p. 893, step2, bullet 1
    
    @IBOutlet weak var searchBar: UISearchBar!;
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!;
    
    // add item controller property
    
    var items: [StoreItem] = [StoreItem]();   //p. 893, step 2, bullet 2
    let queryOptions: [String] = ["movie", "music", "software", "ebook"];
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    func fetchMatchingItems() {
        
        items = [];
        tableView.reloadData();
        
        let searchTerm: String = searchBar.text ?? ""
        let mediaType: String = queryOptions[filterSegmentedControl.selectedSegmentIndex]
        
        if !searchTerm.isEmpty {
            
            // Set up query dictionary.
            let query: [String: String] = [   //p. 893, step 2, bullet 3
                "term":  searchTerm,
                "media": mediaType,
                "lang":  "en_us",
                "limit": "10"
            ];
            
            // Use the item controller to fetch items.
    
            storeItemController.fetchItems(matching: query) {(items: [StoreItem]?) in //p. 893, step 2, bullet 4
                // If successful, use the main queue to set items and reload the table view.
                // Otherwise, print an error to the console.
                if let items: [StoreItem] = items {
                    print("fetched \(items)");
                    self.items = items;   //3 variables with the same name
                    DispatchQueue.main.async {   //p. 894, step 3, bullet 2
                        self.tableView.reloadData();
                    }
                } else {
                    print("could not fetch items for \(mediaType) \(searchTerm)");
                }
            }
            
        }
    }
    
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let item: StoreItem = items[indexPath.row];
        
        // Set label to the item's name.
        // Set detail label to the item's subtitle.
        cell.textLabel?.text = item.trackName;          //p. 893, step 2, bullet 2
        cell.detailTextLabel?.text = item.artistName;   //p. 894, step 4, bullet 1
        
        // Reset the image view to the gray image.
        cell.imageView?.image = UIImage(named: "gray"); //p. 894, step 4, bullet 3
        
        // Initialize a network task to fetch the item's artwork.
        // If successful, use the main queue capture the cell, to initialize a UIImage, and set the cell's image view's image to the
        
        //p. 894, step 4, bullet 3
        let task: URLSessionTask = URLSession.shared.dataTask(with: item.artworkUrl100) {(data: Data?, response: URLResponse?, error: Error?) in
            guard let data: Data = data else {
                print("no artwork data was returned");
                return;
            }
            
            guard let image: UIImage = UIImage(data: data) else {
                print("can't create image from data");
                return;
            }
            
            DispatchQueue.main.async {
                cell.imageView?.image = image;
            }
        }
        
        task.resume();
    }
    
    @IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {
        
        fetchMatchingItems()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath);
        configure(cell: cell, forItemAt: indexPath);
        return cell;
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
    }
}

extension StoreItemListTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchMatchingItems();
        searchBar.resignFirstResponder();
    }
}
