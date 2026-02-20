import { useState } from "react";

interface BrandLogoProps {
  className?: string;
  alt?: string;
}

export function BrandLogo({ className, alt = "CALZADO J&R" }: BrandLogoProps) {
  const [srcIndex, setSrcIndex] = useState(0);
  const candidates = ["/logo.png", "/logo.jpg", "/logo.jpeg"];

  function handleError() {
    setSrcIndex((i) => Math.min(i + 1, candidates.length));
  }

  // If all candidates failed, render an inline SVG fallback
  if (srcIndex >= candidates.length) {
    return (
      <svg className={className} viewBox="0 0 200 60" xmlns="http://www.w3.org/2000/svg" role="img">
        <rect width="100%" height="100%" fill="transparent" />
        <text x="10" y="38" fontSize="28" fill="#0f172a" fontWeight={700}>CALZADO</text>
        <text x="140" y="38" fontSize="28" fill="#b45309" fontWeight={800}>J&amp;R</text>
      </svg>
    );
  }

  return (
    // eslint-disable-next-line @next/next/no-img-element
    <img src={candidates[srcIndex]} alt={alt} className={className} onError={handleError} />
  );
}
