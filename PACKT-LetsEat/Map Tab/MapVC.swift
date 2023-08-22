//
//  MapVC.swift
//  PACKT-LetsEat
//
//  Created by Warba on 18/06/2023.
//

import UIKit
import MapKit
import OSLog
import SwiftUI


class MapVC: UIViewController, UIPopoverPresentationControllerDelegate {


    @IBOutlet var mapView: MKMapView!


    private let manager = MapDataManager()
    var selectedRestaurant: RestaurantItem?

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            case Segue.showDetail.rawValue:
                showRestaurantDetail(segue: segue)
            default:
                print("Seugue not added")
        }
    }
} // MapVC

//MARK: - Extensions

private extension MapVC {
    //MARK: - Functions
    func initialize() {


        mapView.delegate = self
        //max zoom distance a user can zoom into
        mapView.cameraZoomRange = .init(minCenterCoordinateDistance: 5000)


        manager.fetch {(annotaions) in
            setupMap(annotaions)
        }
    }

    func setupMap(_ annotations: [RestaurantItem]) {
        mapView.setRegion(manager.initialRegion(latDelta: 0.5, longDelta: 0.5), animated: true)

        //registering the custom callout view
        mapView.register(SnapShotAnnptationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.addAnnotations(manager.annotations)
    }

    func showRestaurantDetail(segue: UIStoryboardSegue) {
        if let viewController = segue.destination as? RestaurantDetailVC,
           let restaurant = selectedRestaurant {
            viewController.selectedRestaurant = restaurant
        }
    }
}

extension MapVC: MKMapViewDelegate {



    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {

        guard let annotation = mapView.selectedAnnotations.first else { return }
        selectedRestaurant = annotation as? RestaurantItem
        self.performSegue(withIdentifier: Segue.showDetail.rawValue, sender: self)
    }

    //here we create the custom pin and the custom callout "tooltip"
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "custompin"
        guard !annotation.isKind(of: MKUserLocation.self) else {return nil}
        let annotationView: MKAnnotationView


        //the custom call out view instance
        if let customAnnotationView =
            mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView = customAnnotationView

            annotationView.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)


//            let myView = UIView()
//            myView.backgroundColor = .green
//

            let customView = Bundle.main.loadNibNamed("CustomCalloutView", owner: self, options: nil)?.first as! CustomCalloutView
            customView.totalAmountValue.text = "1,000,000.00 KWD"
            customView.totalTransactionsValue.text = "1500000000"

            let widthConstraint = NSLayoutConstraint(item: customView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 290)
            customView.addConstraint(widthConstraint)

            let heightConstraint = NSLayoutConstraint(item: customView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
            customView.addConstraint(heightConstraint)

            av.detailCalloutAccessoryView = customView

            var button = UIButton(type: .detailDisclosure)
            button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            button.tintColor = .secondaryLabel
            av.rightCalloutAccessoryView = button
            annotationView = av
        }
        annotationView.canShowCallout = true

        if let image = UIImage(named: "custom-annotation") {
            annotationView.image = image
            annotationView.centerOffset = CGPoint(
                x: -image.size.width / 2,
                y: -image.size.height / 2
            )
        }
        return annotationView
    }
}

class SnapShotAnnptationView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config() {
        configDetailView()
    }
    
    func configDetailView() {
        
        let snapshotView = UIView()
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        snapshotView.frame.size = .init(width: 150, height: 150)
        snapshotView.backgroundColor = .orange
        
    }
}

struct toolpinView: View {

    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text("Amount Spent")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("1,000.00 KWD")
                        .bold()
                }
                HStack {
                    Text("Total Transactions")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("1234")
                        .bold()
                }
            }
        }
    }

}
