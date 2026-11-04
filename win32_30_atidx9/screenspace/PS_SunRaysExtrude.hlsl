sampler2D gDeferredLightSampler1 : register(s1);
sampler2D gDeferredLightSampler2 : register(s2);
float4 globalScreenSize : register(c41);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float2 vpos : VPOS;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	r0.x = 1 / globalScreenSize.x;
	r0.x = r0.x * globalScreenSize.y;
	r1.xyw = -i.texcoord.xyy;
	r0.yz = r1.xy + 0.5;
	r1.z = r0.x * r0.y;
	r0.x = dot(r0.yz, r0.yz) + 0;
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.yz = r1.zw + float2(1E-05, 0.50001);
	r0.w = dot(r0.yz, r0.yz) + 0;
	r0.w = rsqrt(r0.w);
	r0.yz = r0.ww * r0.yz;
	r0.yz = r0.xx * r0.yz;
	r0.x = r0.x * -1.4144272 + 0.708;
	r0.yz = r0.yz * 0.09090909;
	r1.xy = 0.33333334 * i.vpos.xy;
	r1.xy = frac(abs(r1.xy));
	r1.xy = (i.vpos.xy >= 0) ? r1.xy : -r1.xy;
	r0.w = r1.x * 3 + 1;
	r0.w = r1.y * 9 + r0.w;
	r1.w = 0.11111111;
	r2 = r0.w * r1.w + float4(0.5, 1.5, 2.5, 3.5);
	r1.xy = 0.51 + i.vpos.xy;
	r1.xy = r1.xy * globalScreenSize.zw;
	r1.xy = r1.xy * 4;
	r3 = r0.yzyz * r2.xxyy + r1.xyxy;
	r2 = r0.yzyz * r2.zzww + r1.xyxy;
	r4 = tex2D(gDeferredLightSampler1, r3.xy);
	r3 = tex2D(gDeferredLightSampler1, r3.zw);
	r5 = tex2D(gDeferredLightSampler1, r1.xy);
	r3.yz = r5.xx * float2(1.5, 0.2);
	r1.z = r4.x * 1.45 + r3.y;
	r1.z = r3.x * 1.35 + r1.z;
	r4 = tex2D(gDeferredLightSampler1, r2.xy);
	r2 = tex2D(gDeferredLightSampler1, r2.zw);
	r1.z = r4.x * 1.25 + r1.z;
	r1.z = r2.x * 1.15 + r1.z;
	r2 = r0.w * r1.w + float4(4.5, 5.5, 6.5, 7.5);
	r0.w = r0.w * 0.11111111 + 8.5;
	r3.xy = r0.yz * r0.ww + r1.xy;
	r4 = tex2D(gDeferredLightSampler1, r3.xy);
	r5 = r0.yzyz * r2.xxyy + r1.xyxy;
	r2 = r0.yzyz * r2.zzww + r1.xyxy;
	r6 = tex2D(gDeferredLightSampler1, r5.xy);
	r5 = tex2D(gDeferredLightSampler1, r5.zw);
	r0.y = r6.x * 1.05 + r1.z;
	r0.y = r5.x * 0.95 + r0.y;
	r1 = tex2D(gDeferredLightSampler1, r2.xy);
	r2 = tex2D(gDeferredLightSampler1, r2.zw);
	r0.y = r1.x * 0.85 + r0.y;
	r0.y = r2.x * 0.75 + r0.y;
	r0.y = r4.x * 0.65 + r0.y;
	r0.y = r0.y * 0.10526316;
	r1.x = max(r3.z, r0.y);
	r2 = tex2D(gDeferredLightSampler2, i.texcoord.xy);
	r1.y = max(r0.x, r2.x);
	o = r1.x * r1.y;

	return o;
}
