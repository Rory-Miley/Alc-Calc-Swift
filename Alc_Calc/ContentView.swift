import SwiftUI

// Beverage object
struct beverage: Identifiable{
    let id = UUID()
    let price: String
    let percent: String
    let name: String
    let volume_ethanol: String
    let price_per_ml: String
    let price_as_func_of_pint: String
    let num_of_pints: String
    
    let vol_tot: Int
    let vol_alc: Double
    let ppue: Float
    let pafoap: Float
    let nop: Double
    
    init(price: Double, volume: Int, number: Int, percent: Double, name: String) {
        self.price = String(price)
        self.percent = String(percent)
        self.name = name

        self.vol_tot = number * volume
        self.vol_alc = Double(self.vol_tot) * (percent * 0.01)
        self.volume_ethanol = String(self.vol_alc)
        
        self.ppue = Float(price/self.vol_alc) //price for 1ml alc as float
        self.price_per_ml = String(format: "%.3f", self.ppue) //as string
        
        self.pafoap = 568.26 * 0.045 * self.ppue
        self.price_as_func_of_pint = String(format: "%.2f", self.pafoap)
        
        self.nop = Double(Float(price)/self.pafoap)
        self.num_of_pints = String(format: "%.2f", self.nop)
    }
}

// view handler
struct ContentView: View {
    // State variables to track the current page
    @State var currentPage: Int = 0
    @State var selectedNumber: Int = 1
    @State var beverages: [beverage] = [] // blank array of beverages
    // A view handler to switch between pages
    // this is probabely the worst way to handle this but fuck it lol
    var viewHandler: some View {
        switch currentPage {
        case 0:
            return AnyView(HomePage(currentPage: $currentPage,
                                    selectedNumber: $selectedNumber,
                                    beverages: $beverages))
        case 1:
            return AnyView(AnotherPage(currentPage: $currentPage,
                                       selectedNumber: $selectedNumber,
                                       beverages: $beverages))
        case 2:
            return AnyView(AnotherPage(currentPage: $currentPage,
                                       selectedNumber: $selectedNumber,
                                       beverages: $beverages))
        case 3:
            return AnyView(AnotherPage(currentPage: $currentPage,
                                       selectedNumber: $selectedNumber,
                                       beverages: $beverages))
        case 4:
            return AnyView(AnotherPage(currentPage: $currentPage,
                                       selectedNumber: $selectedNumber,
                                       beverages: $beverages))
        case 5:
            return AnyView(AnotherPage(currentPage: $currentPage,
                                       selectedNumber: $selectedNumber,
                                       beverages: $beverages))
        case 6:
            return AnyView(AnotherPage(currentPage: $currentPage,
                                       selectedNumber: $selectedNumber,
                                       beverages: $beverages))
        case 7:
            return AnyView(AnotherPage(currentPage: $currentPage,
                                       selectedNumber: $selectedNumber,
                                       beverages: $beverages))
        case 99:
            return AnyView(QuickResultPage(currentPage: $currentPage,
                                           beverages: $beverages))
        case 999:
            return AnyView(ResultsPage(currentPage: $currentPage,
                                       selectedNumber: $selectedNumber,
                                       beverages: $beverages))
        default:
            return AnyView(Text("[ERROR] : Invalid page"))
        }
    }
    var body: some View {
        viewHandler
    }
}

//Start screen page 0
struct HomePage: View {
    // A binding variable to update the current page
    @Binding var currentPage: Int
    @Binding var selectedNumber: Int
    @Binding var beverages: [beverage]
    let numbers = Array(1...7)
    var body: some View {
        VStack {
            Spacer()
            Text("Alc - Calc").font(.largeTitle)
            Spacer()
            Text("Select number of items to compare: \(selectedNumber)")
            Picker("Number", selection: $selectedNumber) {
                ForEach(numbers, id: \.self) { number in
                    Text("\(number)")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            Spacer()
            Button("Next") {
                // Change the current page to 1
                // empty the beverages array before starting
                beverages.removeAll()
                currentPage = 1
            }.accentColor(.orange)
            Spacer()
        }
    }
}

// screen that shows detail view
struct AnotherPage: View {
    @Binding var currentPage: Int
    @Binding var selectedNumber: Int
    @Binding var beverages: [beverage]
    
    @State var t_name: String = ""
    @State var t_price: Double = 0
    @State var t_percent: Double = 0
    @State var t_volume: Int = 0
    @State var t_number: Int = 0
    
    // Currency formatter for price
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.currencyCode = "EUR"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    // Number formatter for non-currency fields
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {

        
        VStack {
            Spacer()
            Text("Item \(currentPage) of \(selectedNumber)")
            Spacer()
            
            TextField("Enter item name", text: $t_name)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            Spacer()
            
            Text("Enter the price:")
            TextField("", value: $t_price, formatter: currencyFormatter)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .submitLabel(.done)
                .keyboardType(.decimalPad)
            Spacer()
            
            Text("Enter number of containers:")
            TextField("", value: $t_number, formatter: numberFormatter)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .submitLabel(.done)
                .keyboardType(.numberPad)
            Spacer()
            
            Text("Enter the volume of container:")
            TextField("", value: $t_volume, formatter: numberFormatter)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .submitLabel(.done)
                .keyboardType(.numberPad)
            Spacer()
            
            Text("Enter the percentage:")
            TextField("", value: $t_percent, formatter: numberFormatter)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .submitLabel(.done)
                .keyboardType(.numberPad)
            Spacer()
            
            Button("Next") {
                let ans =  beverage(price: t_price,
                                    volume: t_volume,
                                    number: t_number,
                                    percent: t_percent,
                                    name: t_name)
                beverages.append(ans)
                t_name = ""
                t_price = 0
                t_percent = 0
                t_volume = 0
                t_number = 0
                
                if currentPage < selectedNumber{
                    currentPage += 1
                }
                else if currentPage == selectedNumber {
                    currentPage = 99
                }
                else{
                    currentPage = 0
                }
            }.accentColor(.orange)
            Spacer()
            
        }
    }
}

// quick results
struct QuickResultPage: View{
    @Binding var currentPage: Int
    @Binding var beverages: [beverage]
    
    
    func find_most_alc(bevs: [beverage]) -> String {
        if let temp = bevs.max(by: { $0.vol_alc < $1.vol_alc }) {
            return temp.name
        }
        return "No beverages found" // or whatever default value makes sense
    }
    
    
    func find_best_val(bevs: [beverage]) -> String{
        if let temp = bevs.min(by: {$0.ppue < $1.ppue}) {
            return temp.name
        }
        return "No beverages found" // or whatever default value makes sense
    }
    
    var body: some View{
        VStack{
            Spacer()
            Text("Results").font(.largeTitle)
            Spacer()
            //text showing the best value
            Text("Best value: \(find_best_val(bevs: beverages))")
            Spacer()
            Text("Most Alc: \(find_most_alc(bevs: beverages))")
            Spacer()
            Button("Detailed results"){
                currentPage = 999
            }
            Spacer()
        }
    }
}


// results screen
struct ResultsPage: View{
    // transfer variables
    @Binding var currentPage: Int
    @Binding var selectedNumber: Int
    @Binding var beverages: [beverage]
    
    var body: some View{
        VStack{
            Text("Detailed Results").font(.largeTitle)
            Spacer()
            Table(beverages) {
                TableColumn("Name:", value: \.name)
                TableColumn("Price (€):", value: \.price)
                TableColumn("Volume of ethanol (ml):", value: \.volume_ethanol)
                TableColumn("Price per ml Alc (€):", value: \.price_per_ml)
                TableColumn("Price as func of a pint (€):", value: \.price_as_func_of_pint)
                TableColumn("EQ number of pints:", value:\.num_of_pints)
            }
            Spacer()
            Button("Home"){
                currentPage = 0
                selectedNumber = 1
            }.accentColor(.orange)
        }
    }
}
