import requests

def send_request(method, url, headers=None, data=None):
    """
    Send HTTP request using the 'requests' library.
    """
    try:
        response = requests.request(
            method=method,
            url=url,
            headers=headers,
            data=data
        )
        return response
    except Exception as e:
        print(f"Error sending request: {e}")
        return None
