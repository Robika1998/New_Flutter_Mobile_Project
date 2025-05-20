import 'package:flutter/material.dart';

class PrivacyPolicyModal extends StatelessWidget {
  const PrivacyPolicyModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text('Last updated: June 03, 2024\n\n'),
                    const Text(
                      'This Privacy Policy describes Our policies and procedures on the '
                      'collection, use, and disclosure of Your information when You use '
                      'the Service and tells You about Your privacy rights and how the '
                      'law protects You.\n\n',
                    ),
                    const Text(
                      'We use Your Personal data to provide and improve the Service. By '
                      'using the Service, You agree to the collection and use of '
                      'information in accordance with this Privacy Policy.\n\n',
                    ),
                    const Text(
                      'Interpretation and Definitions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Interpretation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'The words of which the initial letter is capitalized have meanings '
                      'defined under the following conditions. The following definitions '
                      'shall have the same meaning regardless of whether they appear in '
                      'singular or in plural.\n\n',
                    ),
                    const Text(
                      'Definitions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('For the purposes of this Privacy Policy:\n'),
                    _buildListItem(
                      'Account',
                      'A unique account created for You to access our Service.',
                    ),
                    _buildListItem(
                      'Affiliate',
                      'An entity that controls, is controlled by, or is under common control with a party.',
                    ),
                    _buildListItem(
                      'Application',
                      'Refers to MyKeyBox.com, the software program provided by the Company.',
                    ),
                    _buildListItem(
                      'Company',
                      'MyKeyBox LLC, 7565 Haverhill Ln, Maineville, Ohio.',
                    ),
                    _buildListItem('Country', 'Ohio, United States.'),
                    _buildListItem(
                      'Device',
                      'Any device that can access the Service such as a computer, cellphone, or tablet.',
                    ),
                    _buildListItem(
                      'Personal Data',
                      'Any information that relates to an identified or identifiable individual.',
                    ),
                    _buildListItem('Service', 'Refers to the Application.'),
                    _buildListItem(
                      'Service Provider',
                      'A natural or legal person processing data on behalf of the Company.',
                    ),
                    _buildListItem(
                      'Usage Data',
                      'Data collected automatically from the Service infrastructure itself.',
                    ),
                    _buildListItem('You', 'The individual using the Service.'),
                  ],
                ),
              ),
            ),
            // Close button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: '$title: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: desc,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
